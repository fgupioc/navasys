import 'package:flutter/material.dart';
import 'package:navasys/core/theme/app_colors.dart';
import 'package:navasys/shared/widgets/my_alert.dart';

import '../core/services/service.dart';
import '../shared/widgets/app_date_field.dart';
import '../shared/widgets/filter_product.dart';
import 'auth/login_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  DateTime? _fechaPago = DateTime.now();
  final _dateInitCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateInitCtrl.text = AppDateField.format(_fechaPago!);
  }

  Future<void> _onLogout() async {
    final ok = await MyAlert.confirm(
      context,
      title: '¿Seguro que deseas cerrar sesión?',
      text: '',
    );
    if (!ok || !mounted) return;

    await authService.logout();

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          BuildItemOption(
            title: 'Almacén',
            subtitle: 'Principal',
            icon: Icons.home,
          ),
          BuildItemOption(
            title: 'Cambiar contraseña',
            icon: Icons.lock,
          ),
          BuildItemOption(
            title: 'Configuración',
            icon: Icons.settings,
          ),
          BuildItemOption(
            title: 'Cerrar sesión',
            icon: Icons.logout,
            color: AppColors.danger,
            onTap: _onLogout,
          )
        ],
      ),
    );
  }
}

class BuildItemOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  const BuildItemOption({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.color = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [AppShadow.soft],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 14, color: color?.withValues(alpha: 0.6)),
                    ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 20),
          ],
        ),
      ),
    );
  }
}
