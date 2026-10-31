import 'package:dio/dio.dart';
import 'package:navasys/core/auth/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final TokenStorage storage;
  final Dio _refreshDio;
  final void Function()? onSessionExpired;

  AuthInterceptor({
    required this.dio,
    required this.storage,
    required String baseUrl,
    this.onSessionExpired,
  }) : _refreshDio = Dio(BaseOptions(baseUrl: baseUrl));

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    if (options.extra['skipAuth'] == true) return handler.next(options);

    // Sin sesión: no tiene sentido enviar la petición
    if (!await storage.hasSession()) {
      return handler.reject(_sessionExpiredError(options));
    }

    // Refresco proactivo: si el access token ya venció, renovarlo antes de enviar
    if (await storage.isAccessTokenExpired) {
      final newAccess = await _refreshTokens();
      if (newAccess == null) {
        await _clearSession();
        return handler.reject(_sessionExpiredError(options));
      }
    }

    final token = await storage.accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    final status = err.response?.statusCode;

    if (req.extra['skipAuth'] == true || req.extra['retried'] == true) {
      return handler.next(err);
    }

    // 401 = no autenticado. 403 solo cuenta como sesión expirada si el token
    // realmente venció (un 403 por falta de permisos debe llegar a la UI).
    final isAuthError =
        status == 401 || (status == 403 && await storage.isAccessTokenExpired);
    if (!isAuthError) return handler.next(err);

    // Si otra petición ya renovó el token mientras esta esperaba en la cola,
    // basta con reintentar con el token nuevo.
    final usedToken =
    (req.headers['Authorization'] as String?)?.replaceFirst('Bearer ', '');
    final current = await storage.accessToken;
    if (current != null && current != usedToken) {
      return _retry(req, current, handler);
    }

    final newAccess = await _refreshTokens();
    if (newAccess == null) return _expire(handler, err);

    return _retry(req, newAccess, handler);
  }

  /// Devuelve el nuevo access token, o null si no se pudo renovar.
  Future<String?> _refreshTokens() async {
    final refresh = await storage.refreshToken;
    if (refresh == null) return null;

    try {
      // ⚠️ Ajusta la ruta y el body a lo que exponga tu backend
      final res = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refresh},
      );
      final newAccess = res.data['accessToken'] as String;
      final newRefresh = (res.data['refreshToken'] as String?) ?? refresh;
      await storage.save(accessToken: newAccess, refreshToken: newRefresh);
      return newAccess;
    } catch (_) {
      return null;
    }
  }

  Future<void> _retry(
      RequestOptions req,
      String token,
      ErrorInterceptorHandler handler,
      ) async {
    try {
      req.headers['Authorization'] = 'Bearer $token';
      req.extra['retried'] = true;
      handler.resolve(await dio.fetch(req));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<void> _expire(ErrorInterceptorHandler handler, DioException err) async {
    await _clearSession();
    handler.next(_sessionExpiredError(err.requestOptions));
  }

  /// Limpia la sesión y avisa UNA sola vez, aunque haya varias peticiones en cola.
  Future<void> _clearSession() async {
    final hadSession = await storage.hasSession();
    await storage.clear();
    if (hadSession) onSessionExpired?.call();
  }

  DioException _sessionExpiredError(RequestOptions options) => DioException(
    requestOptions: options,
    type: DioExceptionType.cancel,
    error: 'Sesión expirada',
  );
}