import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CartIconButton extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;

  const CartIconButton({
    super.key,
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
      offset: const Offset(-2, 2), // ajusta la posición del badge
      child: Material(
        color: AppColors.primary.withValues(alpha: 0.2), // fondo del círculo
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.shopping_cart,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}