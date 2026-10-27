import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum FiltroPrestamo {
  todos('Todos'),
  activos('Bebida'),
  abarrotes('Abarrotes'),
  pagados('Limpieza'),
  vencidos('Otros');

  const FiltroPrestamo(this.label);

  final String label;
}

class FilterProduct extends StatelessWidget {
  final FiltroPrestamo seleccionado;
  final ValueChanged<FiltroPrestamo> onChanged;

  const FilterProduct({super.key, required this.seleccionado, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filtro in FiltroPrestamo.values)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _FiltroItem(
                label: filtro.label,
                activo: filtro == seleccionado,
                onTap: () => onChanged(filtro),
              ),
            ),
        ],
      ),
    );
  }
}

class _FiltroItem extends StatelessWidget {
  const _FiltroItem({required this.label, required this.activo, required this.onTap});

  final String label;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: activo ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: activo ? null : Border.all(color: AppColors.textSecondary, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
            color: activo ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
