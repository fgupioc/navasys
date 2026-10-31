import 'package:flutter/material.dart';

import '../../features/auth/login_screen.dart';
import '../auth/token_storage.dart';
import '../network/api_client.dart';
import 'auth_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

late final ApiClient apiClient;
late final AuthService authService;

void setupServices() {
  apiClient = ApiClient(
    storage: TokenStorage(),
    onSessionExpired: () => navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    ),
  );

  authService = AuthService(apiClient);
}
