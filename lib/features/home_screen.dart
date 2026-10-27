import 'package:flutter/material.dart';
import 'package:navasys/core/theme/app_colors.dart';

import '../shared/models/product_more.dart';
import '../shared/widgets/header_vendedor.dart';
import '../shared/widgets/product_more_sale.dart';
import '../shared/widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: ListView(
        children: [
          Column(
            children: [
              HeaderVendedor(nombre: 'Juan', rol: 'Vendedor', cajaAbierta: true),
              const SizedBox(height: 20),
              ResumenGrid(
                ventasHoy: 245.50,
                totalProductos: 322,
                stockBajo: 5,
                almacen: 'Principal',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BuildIcon(label: 'Consultar\nprecio', icon: Icons.qr_code_scanner),
                  BuildIcon(
                    label: 'Ingresar\nMercadería',
                    icon: Icons.arrow_circle_down_outlined,
                  ),
                  BuildIcon(
                    label: 'Registrar\nproducto',
                    icon: Icons.sticky_note_2_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [AppShadow.soft],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lo más vendido hoy',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Por unidades',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    ProductMoreSale(
                      index: 0,
                      product: ProductMore(name: 'Producto A', price: 150.00, quantity: 15),
                    ),
                    ProductMoreSale(
                      index: 1,
                      product: ProductMore(name: 'Producto B', price: 200.00, quantity: 10),
                    ),
                    ProductMoreSale(
                      index: 2,
                      product: ProductMore(name: 'Producto C', price: 100.00, quantity: 8),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.primary, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Recuerda registrar tus ventas y mantener tu inventario actualizado.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BuildIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const BuildIcon({super.key, required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [AppShadow.soft],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
