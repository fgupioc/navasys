import 'package:dio/dio.dart';
import 'package:navasys/core/network/api_client.dart';

import '../auth/data/login_response.dart';

class AuthService {
  final ApiClient api;

  AuthService(this.api);

  Future<void> login(String username, String password) async {
    try {
      final res = await api.dio.post('/auth/login',
        data: {'username': username, 'password': password, 'type': 'password'},
        options: Options(extra: {'skipAuth': true}), // no adjuntar token aquí
      );
      final data = LoginResponse.fromJson(res.data);
      await api.storage.save(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Usuario o contraseña incorrecta');
      }
      throw Exception('No se pudo conectar con el servidor');
    }
  }

  Future<bool> isLoggedIn() => api.storage.hasSession();

  Future<void> logout() => api.storage.clear();
}
