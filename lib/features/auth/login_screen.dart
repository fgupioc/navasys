import 'package:flutter/material.dart';
import 'package:navasys/core/services/service.dart';
import 'package:navasys/core/theme/app_colors.dart';
import 'package:navasys/shared/widgets/my_alert.dart';
import 'package:navasys/shared/widgets/my_loader.dart';

import '../../shared/widgets/app_text_field.dart';
import '../dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  String? _userError;
  String? _passError;

  @override
  void initState() {
    super.initState();
    _userCtrl.addListener(() {
      if (_userError != null && _userCtrl.text.isNotEmpty) {
        setState(() {
          _userError = null;
        });
      }
    });

    _passCtrl.addListener(() {
      if (_passError != null && _passCtrl.text.isNotEmpty) {
        setState(() {
          _passError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _userCtrl.text.trim();
    final pass = _passCtrl.text;

    setState(() {
      _userError = email.isEmpty ? 'El usuario es obligatorio' : null;
      _passError = email.isEmpty ? 'La contraseña es obligatorio' : null;
    });

    if (_userError != null || _passError != null) return;

    MyLoader.show(context, message: 'Iniciando sesión...');
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
    });

    try {
      await authService.login(email, pass);
      if (!mounted) return;
      MyLoader.hide(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      MyLoader.hide(context);
      MyAlert.error(
        context,
        'Error al iniciar sessión',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Widget _fieldError(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 4),
      child: Text(
        error,
        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.red.shade700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icono.png',
                        width: 90,
                        height: 90,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NovaSys',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Minimarket',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ingresa tus credenciales para continuar',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _userCtrl,
                    hint: 'Usuario',
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                  ),
                  _fieldError(_userError),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passCtrl,
                    hint: 'Contraseña',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                  ),
                  _fieldError(_passError),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _loading ? 'Ingresando...' : 'Iniciar sesión',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
