import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navasys/features/home_screen.dart';
import 'package:navasys/features/inventory_screen.dart';
import 'package:navasys/features/pos_screen.dart';
import 'package:navasys/features/sales_screen.dart';
import 'package:navasys/shared/widgets/app_bar_build.dart';

import '../core/theme/app_colors.dart';
import '../shared/widgets/app_navigator_bar.dart';
import 'more_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SalesScreen();
      case 3:
        return const InventoryScreen();
      case 4:
        return const MoreScreen();
      default:
        return const PosScreen();
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBarBuild(),
        body: _buildScreen(_currentIndex),
        bottomNavigationBar: MyNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
        ),
        floatingActionButton: _fab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () {
        _onBottomNavTap(2);
      },
      shape: const CircleBorder(),
      backgroundColor: AppColors.textPrimary,
      child: const Icon(Icons.point_of_sale, color: Colors.white, size: 30,),
    );
  }
}
