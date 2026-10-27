import 'package:flutter/material.dart';
import 'package:navasys/core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = const Color(0xFF2F6BE8),
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [AppShadow.soft],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3D5A8C),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: valueColor ?? const Color(0xFF1E2A4A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResumenGrid extends StatelessWidget {
  final double ventasHoy;
  final int totalProductos;
  final int stockBajo;
  final String almacen;

  const ResumenGrid({
    super.key,
    required this.ventasHoy,
    required this.totalProductos,
    required this.stockBajo,
    required this.almacen,
  });

  static const _rojo = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.trending_up,
                label: 'Ventas hoy',
                value: 'S/ ${ventasHoy.toStringAsFixed(2)}',
              ),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: StatCard(
                icon: Icons.inventory_2_outlined,
                label: 'Productos',
                value: '$totalProductos',
              ),
            ),
          ],
        ),
        const SizedBox(height: gap),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.warning_rounded,
                iconColor: _rojo,
                label: 'Stock bajo',
                value: '$stockBajo',
                valueColor: stockBajo > 0 ? _rojo : null,
              ),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: StatCard(
                icon: Icons.warehouse_outlined,
                label: 'Almacén',
                value: almacen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
