import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../services/navigation_service.dart';
import '../common/app_text.dart';
import '../dialogs/confirmation_dialog.dart';
import '../dialogs/success_dialog.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await provider.loadProducts();
          },
          child: ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () {
                    context.read<NavigationService>().navigateToProductScreen(
                          ProductScreen.edit,
                          productId: product.id,
                        );
                  },
                  title: AppText(
                    product.productName,
                    weight: FontWeight.w500,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.description != null)
                        AppText(
                          product.description!,
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context
                              .read<NavigationService>()
                              .navigateToProductScreen(
                                ProductScreen.edit,
                                productId: product.id,
                              );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _handleDelete(
                            context, product.id, product.productName),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleDelete(
      BuildContext context, String productId, String productName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Delete Product',
        content:
            'Are you sure you want to delete $productName? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel',
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await context.read<ProductProvider>().deleteProduct(productId);

      if (success && context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => const AppSuccessDialog(
            title: 'Successful!',
            message: 'Product deleted successfully',
          ),
        );
      }
    }
  }
}
