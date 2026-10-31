import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';


class AppBarNav extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarNav({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child:  AppBar(
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
