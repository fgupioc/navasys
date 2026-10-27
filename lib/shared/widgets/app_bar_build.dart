import 'package:flutter/material.dart';
import 'package:navasys/shared/widgets/modal_cart.dart';

import '../../core/theme/app_colors.dart';
import '../states/cart_controller.dart';
import 'cart_icon_header.dart';

class AppBarBuild extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBuild({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: AppBar(
            primary: false,
            toolbarHeight: 64,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 64,
            leading: Padding(
              padding: EdgeInsets.only(left: 20),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset('assets/images/icono.png', width: 100, height: 100),
              ),
            ),
            titleSpacing: 10,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NovaSys',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Minimarket',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                )
              ],
            ),
            actions: [
              Center(
                child: ListenableBuilder(
                  listenable: cart,
                  builder: (context, _) => CartIconButton(
                    count: cart.totalUnidades,
                    onPressed: () {
                      showDialog(context: context, builder: (_) => ModalCart() );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
