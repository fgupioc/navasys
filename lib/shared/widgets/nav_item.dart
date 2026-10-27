

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final void Function()? onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? AppColors.info : AppColors.textSecondary),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? AppColors.info : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
