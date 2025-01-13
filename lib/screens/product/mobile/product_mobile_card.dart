import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/product.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';

class ProductMobileCard extends StatelessWidget {
  final Product product;

  const ProductMobileCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  product.productName,
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () {
                      // Handle edit
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Delete'),
                    onTap: () {
                      // Handle delete
                    },
                  ),
                ],
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              _buildInfoItem('Price', '₦${product.price}'),
              const Gap(16),
              _buildInfoItem('Quantity', product.quantity.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          size: 12,
          color: Colors.grey[600],
        ),
        const Gap(4),
        AppText(
          value,
          size: 14,
          weight: FontWeight.w500,
        ),
      ],
    );
  }
}
