import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/product_content.dart';
import '../common/app_text.dart';

class ProductEmptyState extends StatelessWidget {
  const ProductEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_product.png',
            height: 160,
            width: 120,
          ),
          const Gap(24),
          const AppText(
            'Add your products and services to save time\ncreating your next invoice',
            size: 24,
            weight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          const Center(
            child: SizedBox(
              width: 200,
              child: CreateProductButton(),
            ),
          ),
        ],
      ),
    );
  }
}
