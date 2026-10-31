import 'package:dio/dio.dart';
import 'package:navasys/core/auth/token_storage.dart';

import 'auth_interceptor.dart';

class ApiClient {
  static const baseUrl = 'http://192.168.43.67:8020/novasys';

  final TokenStorage storage;
  late final Dio dio;

  ApiClient({required this.storage, void Function()? onSessionExpired}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
     AuthInterceptor(
       dio: dio,
       storage: storage,
       baseUrl: baseUrl,
       onSessionExpired: onSessionExpired,
      )
    );
  }
}