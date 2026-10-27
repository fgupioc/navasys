import 'package:flutter/material.dart';
import 'package:navasys/core/theme/app_colors.dart';

/// Tarjeta de saludo con estado de caja.
/// Uso:
///   HeaderVendedor(nombre: 'Juan', rol: 'Vendedor', cajaAbierta: true)
class HeaderVendedor extends StatelessWidget {
  final String nombre;
  final String rol;
  final bool cajaAbierta;
  final VoidCallback? onTapCaja;

  const HeaderVendedor({
    super.key,
    required this.nombre,
    required this.rol,
    this.cajaAbierta = true,
    this.onTapCaja,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: const [AppShadow.soft],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE0EAFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                color: Color(0xFF3B6FE0), size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hola, $nombre!',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2A4A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rol,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5B7BB5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _ChipCaja(abierta: cajaAbierta, onTap: onTapCaja),
        ],
      ),
    );
  }
}

class _ChipCaja extends StatelessWidget {
  final bool abierta;
  final VoidCallback? onTap;

  const _ChipCaja({required this.abierta, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = abierta ? const Color(0xFFDDF5E6) : const Color(0xFFFDE4E4);
    final dot = abierta ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final fg = abierta ? const Color(0xFF166534) : const Color(0xFF991B1B);

    return Material(
      color: bg,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                abierta ? 'Caja abierta' : 'Caja cerrada',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}