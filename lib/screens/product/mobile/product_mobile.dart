import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/mobile/create_product_mobile.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/mobile/product_mobile_card.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/loading_overlay.dart';
import '../../../widgets/product/product_empty_state.dart';

class ProductMobile extends StatefulWidget {
  const ProductMobile({super.key});

  @override
  State<ProductMobile> createState() => _ProductMobileState();
}

class _ProductMobileState extends State<ProductMobile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: Scaffold(
            body: Column(
              children: [
                // Search Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      provider.searchProducts(value);
                    },
                  ),
                ),

                // Product List
                Expanded(
                  child: provider.products.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.products.length,
                          separatorBuilder: (context, index) => const Gap(16),
                          itemBuilder: (context, index) {
                            final product = provider.products[index];
                            return ProductMobileCard(product: product);
                          },
                        )
                      : const ProductEmptyState(isMobile: true),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateProductMobile(),
                  ),
                );
              },
              backgroundColor: const Color(0xFFE04403),
              label: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white),
                  Gap(4),
                  AppText(
                    'New Product',
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
