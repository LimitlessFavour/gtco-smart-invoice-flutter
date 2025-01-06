import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/product/product_empty_state.dart';
import '../../services/navigation_service.dart';
import 'package:provider/provider.dart';

class ProductContent extends StatelessWidget {
  const ProductContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'All Products',
                size: 24,
                weight: FontWeight.w600,
              ),
              CreateProductButton(),
            ],
          ),
          const Gap(24),

          // Main Content
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC6C1C1)),
              ),
              child: const Column(
                children: [
                  ProductSearchRow(),
                  Gap(24),
                  ProductTableHeader(),
                  Gap(24),
                  Expanded(child: ProductEmptyState()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateProductButton extends StatelessWidget {
  const CreateProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<NavigationService>().navigateToProductScreen(ProductScreen.create);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE04403),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              'New Product',
              color: Colors.white,
              weight: FontWeight.w500,
            ),
            Gap(4),
            Icon(Icons.add, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class ProductTableHeader extends StatelessWidget {
  const ProductTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE04403),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              'Product Name',
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: AppText(
              'Price',
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: AppText(
              'Image',
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: AppText(
              'Quantity',
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductSearchRow extends StatelessWidget {
  const ProductSearchRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Field
        SizedBox(
          width: 252,
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Product',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            // TODO: Handle import file
          },
          icon: const Text(
            'Import a file',
            style: TextStyle(
              color: Color(0xFF00A651),
              fontWeight: FontWeight.w500,
            ),
          ),
          label: const Icon(
            Icons.file_upload_outlined,
            color: Color(0xFF00A651),
          ),
        ),
      ],
    );
  }
}
