import 'package:flutter/material.dart';
import 'package:navasys/features/scan_screen.dart';
import 'package:navasys/shared/widgets/filter_product.dart';

import '../shared/models/demo/Producto.dart';
import '../shared/states/cart_controller.dart';
import '../shared/widgets/app_text_field.dart';
import '../shared/widgets/product_card.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  FiltroPrestamo _filtro = FiltroPrestamo.todos;

  void _seleccionarProducto(Producto p) {
    final ok = cart.agregar(p);
    if (!ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Sin stock suficiente de ${p.nombre}')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 16),
          FilterProduct(
            seleccionado: _filtro,
            onChanged: (f) => setState(() => _filtro = f),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 310,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: productos.length,
              itemBuilder: (_, i) {
                final p = productos[i];
                return ProductCard(
                  name: p.nombre,
                  code: p.codigo,
                  imageUrl: p.imagenUrl,
                  price: p.precio,
                  offerPrice: p.precioOferta,
                  stock: p.stock,
                  selected: cart.contiene(p),
                  onTap: () => _seleccionarProducto(p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            hint: 'Buscar producto por nombre o código',
            icon: Icons.search,
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScanScreen()),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            fixedSize: const Size(50, 50),
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ],
    );
  }
}
