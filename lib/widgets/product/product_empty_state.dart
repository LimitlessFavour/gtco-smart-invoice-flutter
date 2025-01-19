import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../screens/product/product_list_content.dart';
import '../common/app_text.dart';

class ProductEmptyState extends StatelessWidget {
  final bool isMobile;

  const ProductEmptyState({
    super.key,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_product.png',
            height: isMobile ? 120 : 160,
            width: isMobile ? 90 : 120,
          ),
          Gap(isMobile ? 16 : 24),
          AppText(
            'Add your products and services to save time\ncreating your next invoice',
            size: isMobile ? 18 : 24,
            weight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          Gap(isMobile ? 16 : 24),
          if (!isMobile)
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
