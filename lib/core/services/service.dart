// lib/core/services/service.dart
import 'package:flutter/material.dart';

import '../../features/auth/login_screen.dart';
import '../auth/token_storage.dart';
import '../network/api_client.dart';
import 'auth_service.dart';

late final ApiClient apiClient;
late final AuthService authService;

void setupServices() {
  apiClient = ApiClient(
    storage: TokenStorage.instance,
    onSessionExpired: () async {
      await TokenStorage.instance.clear();
      goToLogin();
    },
  );
  authService = AuthService(apiClient);
}

final navigatorKey = GlobalKey<NavigatorState>();

void goToLogin() {
  navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (_) => false,
  );
}
