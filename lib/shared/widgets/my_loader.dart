import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart'; // ajusta a tu paquete

class MyLoader {
  static bool _isShowing = false;

  static void show(BuildContext context, {String message = 'Cargando...'}) {
    if (_isShowing) return;
    _isShowing = true;

    showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierLabel: 'loader',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => PopScope(
        canPop: false, // bloquea el botón atrás
        child: _LoaderScreen(message: message),
      ),
      transitionBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    ).then((_) => _isShowing = false); // se resetea aunque lo cierre otro
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;
    _isShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _LoaderScreen extends StatelessWidget {
  final String message;
  const _LoaderScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryDark,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _NovasysLogo(),
            const SizedBox(height: 40),
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3.5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NovasysLogo extends StatelessWidget {
  const _NovasysLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 40,
              color: Colors.white,
              letterSpacing: -1,
            ),
            children: [
              TextSpan(text: 'Nova', style: TextStyle(fontWeight: FontWeight.w800)),
              TextSpan(text: 'sys', style: TextStyle(fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'MINIMARKET',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 4,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}