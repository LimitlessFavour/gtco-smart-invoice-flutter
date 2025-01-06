import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            // Product Name
            Expanded(
              flex: 2,
              child: Text(
                product.productName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF344054),
                ),
              ),
            ),
            // Price
            Expanded(
              child: Text(
                '₦${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF667085),
                ),
              ),
            ),
            // Image
            Expanded(
              child: product.image != null
                  ? Image.network(
                      product.image!,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
            // Quantity
            Expanded(
              child: Text(
                product.quantity.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF667085),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 