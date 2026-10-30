import 'package:flutter/material.dart';
import 'package:navasys/features/productos_tab_screen.dart';

import '../core/theme/app_colors.dart';
import 'movimientos_tab_screem.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textPrimary,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            unselectedLabelStyle:
            TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            indicatorColor: AppColors.primary,
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.textHint,
            tabs: [
              Tab(text: 'Productos'),
              Tab(text: 'Movimientos'),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                ProductosTabScreen(),
                MovimientosTabScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
