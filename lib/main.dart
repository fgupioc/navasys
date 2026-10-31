import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/auth/token_storage.dart';
import 'core/services/service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard_screen.dart';

final tokenStorage = TokenStorage.instance;

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  setupServices();
  await tokenStorage.init();
  runApp(MainApp(hasSession: tokenStorage.currentUser != null));
  FlutterNativeSplash.remove();
}

class MainApp extends StatelessWidget {
  final bool hasSession;
  const MainApp({super.key, required this.hasSession});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: hasSession ? const DashboardScreen() : const LoginScreen(),
    );
  }
}