import 'package:flutter/material.dart';
import 'package:navasys/shared/models/product_more.dart';

import '../../core/theme/app_colors.dart';

class ProductMoreSale extends StatelessWidget {
  final int index;
  final ProductMore product;

  const ProductMoreSale({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              '${index + 1}',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              product.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${product.quantity} uds.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
