import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String code;
  final String imageUrl;
  final double price;
  final double? offerPrice;
  final int stock;
  final bool selected;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.price,
    this.offerPrice,
    required this.stock,
    required this.selected,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  static const _orange = Color(0xFFF97316);
  static const _blue = Color(0xFF3B82F6);
  static const _dark = Color(0xFF1E293B);
  static const _grey = Color(0xFF94A3B8);
  static const _border = Color(0xFFE2E8F0);

  bool _hover = false;

  bool get _isOffer => widget.offerPrice != null && widget.offerPrice! < widget.price;

  String _fmt(double v) => 'S/ ${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final highlighted = _hover || widget.selected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlighted ? _blue : _border,
              width: highlighted ? 1.5 : 1,
            ),
            boxShadow: highlighted
                ? [
                    BoxShadow(
                      color: _blue.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    children: [
                      // Imagen
                      SizedBox(
                        height: 95,
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: _grey,
                            size: 48,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _dark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Cod: ${widget.code}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: _grey),
                      ),
                      const Spacer(),

                      // Precios
                      if (_isOffer) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _fmt(widget.price),
                            style: const TextStyle(
                              fontSize: 14,
                              color: _grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _fmt(widget.offerPrice!),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _orange,
                            ),
                          ),
                        ),
                      ] else
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _fmt(widget.price),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _dark,
                            ),
                          ),
                        ),

                      const Divider(height: 20, color: _border),

                      // Pie: etiqueta OFERTA o stock
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _isOffer
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _orange.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: _orange.withOpacity(0.4)),
                                ),
                                child: const Text(
                                  'OFERTA',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _orange,
                                  ),
                                ),
                              )
                            : Text(
                                'Stock: ${widget.stock}',
                                style: const TextStyle(fontSize: 13, color: _grey),
                              ),
                      ),
                    ],
                  ),
                ),

                // Barra naranja lateral para ofertas
                if (_isOffer)
                  const Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(width: 4, child: ColoredBox(color: _orange)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
