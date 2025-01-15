import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../common/app_text.dart';

class ProductSelectionDialog extends StatefulWidget {
  const ProductSelectionDialog({super.key});

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Select Product',
              size: 20,
              weight: FontWeight.w600,
            ),
            const Gap(16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<ProductProvider>().searchProducts(value);
              },
            ),
            const Gap(16),
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                    child: AppText(
                      provider.error!,
                      color: Colors.red,
                    ),
                  );
                }

                final products = provider.products;
                if (products.isEmpty) {
                  return const Center(
                    child: AppText('No products found'),
                  );
                }

                return SizedBox(
                  height: 300,
                  child: ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: AppText(product.productName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              product.description,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            AppText(
                              '₦${product.price}',
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop(product);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
