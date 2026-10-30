import 'package:flutter/material.dart';
import 'package:navasys/shared/models/demo/Producto.dart';

import '../core/theme/app_colors.dart';
import '../shared/widgets/filter_product.dart';

class ProductosTabScreen extends StatefulWidget {
  const ProductosTabScreen({super.key});

  @override
  State<ProductosTabScreen> createState() => _ProductosTabScreenState();
}

class _ProductosTabScreenState extends State<ProductosTabScreen>
    with AutomaticKeepAliveClientMixin {
  final _searchCtrl = TextEditingController();
  FiltroPrestamo _filtro = FiltroPrestamo.todos;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  textInputAction: TextInputAction.search,
                  onChanged: (q) {
                    // TODO: filtrar productos
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar producto...',
                    hintStyle: const TextStyle(color: Color(0xFF8A93A6)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF5B6478)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.qr_code_scanner, color: AppColors.primary),
                      tooltip: 'Escanear código',
                      onPressed: () {
                        // TODO: abrir lector de código de barras
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
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
                child: const Icon(Icons.search, color: Colors.white, size: 28, fontWeight:  FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilterProduct(
            seleccionado: _filtro,
            onChanged: (f) => setState(() => _filtro = f),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 50),
            itemCount: productos.length,
            itemBuilder: (_, i) {
              final p = productos[i];
              return BuildItemProduct(producto: p);
            },
          ),
        ),
      ],
    );
  }
}

class BuildItemProduct extends StatelessWidget {
  final Producto producto;

  const BuildItemProduct({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 80,
                child: Image.network(
                  producto.imagenUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textHint,
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stock: ${producto.stock}  |  Min: 5',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Normal',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.successDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: AppColors.textHint, thickness: 1),
        ],
      ),
    );
  }
}
