import 'package:flutter/foundation.dart';

class AuthNotifier extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  void login() { _loggedIn = true; notifyListeners(); }
  void logout() { _loggedIn = false; notifyListeners(); }
}