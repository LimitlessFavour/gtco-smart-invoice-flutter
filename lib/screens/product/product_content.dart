import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/product/product_empty_state.dart';
import '../../widgets/product/product_tile.dart';

class ProductContent extends StatefulWidget {
  const ProductContent({super.key});

  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
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
        // // Show error if exists
        // if (provider.error != null) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: AppText(provider.error!),
        //         action: SnackBarAction(
        //           label: 'Dismiss',
        //           textColor: Colors.white,
        //           onPressed: () {
        //             provider.clearError();
        //           },
        //         ),
        //       ),
        //     );
        //     provider.clearError(); // Clear error after showing
        //   });
        // }

        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'All Products',
                      size: 24,
                      weight: FontWeight.w600,
                    ),
                    Row(
                      children: [
                        SearchBox(),
                        Gap(16),
                        CreateProductButton(),
                      ],
                    ),
                  ],
                ),
                const Gap(24),

                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE04403),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: AppText(
                          'Product Name',
                          color: Colors.white,
                          weight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: AppText(
                          'Price',
                          color: Colors.white,
                          weight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: AppText(
                          'Quantity',
                          color: Colors.white,
                          weight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: AppText(
                          'Action',
                          color: Colors.white,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Product List
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: provider.products.isNotEmpty
                        ? ListView.builder(
                            itemCount: provider.products.length,
                            itemBuilder: (context, index) {
                              final product = provider.products[index];
                              return ProductTile(product: product);
                            },
                          )
                        : const ProductEmptyState(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D5DD)),
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
        onChanged: (value) {
          context.read<ProductProvider>().searchProducts(value);
        },
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
        context
            .read<NavigationService>()
            .navigateToProductScreen(ProductScreen.create);
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
