import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:intl/intl.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    );

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
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Row(
          children: [
            // Product Name
            Expanded(
              flex: 2,
              child: Text(
                product.productName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF344054),
                ),
              ),
            ),
            // Price
            Expanded(
              child: Text(
                currencyFormatter.format(product.price),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF344054),
                ),
              ),
            ),
            // Quantity
            Expanded(
              child: Text(
                product.quantity.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF344054),
                ),
              ),
            ),
            // Actions
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      // TODO: Handle edit
                    },
                    color: const Color(0xFF667085),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      // TODO: Handle delete
                    },
                    color: const Color(0xFF667085),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 