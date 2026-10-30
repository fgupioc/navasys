import 'package:flutter/material.dart';
import 'package:navasys/shared/widgets/process_payment.dart';

import '../../core/theme/app_colors.dart';
import '../states/cart_controller.dart';
import 'my_alert.dart';

class ModalCart extends StatelessWidget  {
  const ModalCart({super.key});

  static const _dark = Color(0xFF1E2A5A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _green = Color(0xFF16A34A);

  static String fmt(double v) => 'S/ ${v.toStringAsFixed(2)}';
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        final items = cart.items;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(
              'Carrito (${cart.totalUnidades})',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: _dark),
            ),
            actions: [
              if (items.isNotEmpty)
                TextButton(
                  onPressed: () => _confirmarVaciar(context),
                  child: const Text('Vaciar',
                      style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
          body: items.isEmpty
              ? const _CarritoVacio()
              : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, color: _border),
            itemBuilder: (_, i) => _CartItemTile(item: items[i]),
          ),
          bottomNavigationBar: _ResumenPago(items),
        );
      },
    );
  }
}

Future<void> _confirmarVaciar(BuildContext context) async {
  final ok = await MyAlert.confirm(
    context,
    title: 'Vaciar carrito',
    text: '¿Quitar todos los productos?',
    confirmText: 'Sí, eliminar',
    type: AlertType.question,
    confirmColor: const Color(0xFFD33F49),
  );
  if (ok != true) return;

  cart.vaciar();

  if (!context.mounted) return;
  Navigator.pop(context);
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = item.producto;
    final enOferta = p.precioOferta != null && p.precioOferta! < p.precio;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Imagen
          SizedBox(
            width: 52,
            height: 64,
            child: Image.network(
              p.imagenUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: ModalCart._grey),
            ),
          ),
          const SizedBox(width: 12),

          // Nombre y precio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, color: ModalCart._dark),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      ModalCart.fmt(item.precioUnitario),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: enOferta
                            ? const Color(0xFFF97316)
                            : ModalCart._dark,
                      ),
                    ),
                    if (enOferta) ...[
                      const SizedBox(width: 6),
                      Text(
                        ModalCart.fmt(p.precio),
                        style: const TextStyle(
                          fontSize: 12,
                          color: ModalCart._grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Cantidad
          _QtyStepper(
            cantidad: item.cantidad,
            puedeSumar: item.cantidad < p.stock,
            onMenos: () => cart.quitarUno(p),
            onMas: () => cart.agregar(p),
          ),

          // Eliminar
          IconButton(
            onPressed: () => cart.eliminar(p),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int cantidad;
  final bool puedeSumar;
  final VoidCallback onMenos;
  final VoidCallback onMas;

  const _QtyStepper({
    required this.cantidad,
    required this.puedeSumar,
    required this.onMenos,
    required this.onMas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ModalCart._border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, onMenos),
          SizedBox(
            width: 24,
            child: Text(
              '$cantidad',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: ModalCart._dark),
            ),
          ),
          _btn(Icons.add, puedeSumar ? onMas : null),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? ModalCart._border : ModalCart._dark,
        ),
      ),
    );
  }
}

class _ResumenPago extends StatelessWidget {
  final List<CartItem> items;
  const _ResumenPago(this.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: ModalCart._border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (items.isNotEmpty) ...[
              _fila('Subtotal', cart.subtotal),
              const SizedBox(height: 8),
              _fila('Descuento', cart.descuento, negativo: true),
              const Divider(height: 24, color: ModalCart._border),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: ModalCart._dark)),
                  Text(ModalCart.fmt(cart.total),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: ModalCart._dark)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(context: context, builder: (_) => ProcessPayment() );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ModalCart._green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.payments_outlined),
                  label: Text(
                    'Cobrar  ${ModalCart.fmt(cart.total)}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fila(String label, double valor, {bool negativo = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: ModalCart._grey)),
        Text(
          '${negativo && valor > 0 ? '- ' : ''}${ModalCart.fmt(valor)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: negativo && valor > 0
                ? ModalCart._green
                : ModalCart._dark,
          ),
        ),
      ],
    );
  }
}

class _CarritoVacio extends StatelessWidget {
  const _CarritoVacio();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 72, color: ModalCart._border),
          SizedBox(height: 12),
          Text('El carrito está vacío',
              style: TextStyle(fontSize: 16, color: ModalCart._grey)),
        ],
      ),
    );
  }
}