import 'package:flutter/material.dart';
import 'package:navasys/core/theme/app_colors.dart';

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
  FiltroPrestamo _filtro = FiltroPrestamo.todos;

  @override
  void initState() {
    super.initState();
    _dateInitCtrl.text = AppDateField.format(_fechaPago!);
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }
          ),
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
