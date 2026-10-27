import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'nav_item.dart';

class MyNavigationBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const MyNavigationBar({super.key, required this.currentIndex, required this.onTap});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return  BottomAppBar(
      color: AppColors.background,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.home,
              label: 'Inicio',
              active: widget.currentIndex == 0,
              onTap: () => widget.onTap(0),
            ),
            NavItem(
              icon: Icons.list_alt_outlined,
              label: 'Ventas',
              active: widget.currentIndex == 1,
              onTap: () => widget.onTap(1),
            ),
            SizedBox(width: 40),
            NavItem(
              icon: Icons.inventory,
              label: 'Inventario',
              active: widget.currentIndex == 3,
              onTap: () => widget.onTap(3),
            ),
            NavItem(
              icon: Icons.more_horiz,
              label: 'Más',
              active: widget.currentIndex == 4,
              onTap: () => widget.onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}
