import 'package:flutter/material.dart';

import 'core/auth/token_storage.dart';
import 'core/services/service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  final hasSession = await tokenStorage.hasSession();
  runApp(MainApp(hasSession: hasSession));
}

final navigatorKey = GlobalKey<NavigatorState>();
final tokenStorage = TokenStorage();

void goToLogin() {
  navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => LoginScreen()),
        (_) => false,
  );
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
      home: hasSession ? const DashboardScreen() : LoginScreen(),
    );
  }
}
