import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../dialogs/confirmation_dialog.dart';
import '../dialogs/success_dialog.dart';
import 'package:intl/intl.dart';
import '../../services/navigation_service.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;

  const ProductTile({
    super.key,
    required this.product,
    this.onEdit,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AppText(product.productName),
            ),
            Expanded(
              child: AppText(
                NumberFormat.currency(symbol: '₦').format(product.price),
              ),
            ),
            Expanded(
              child: AppText(product.quantity.toString()),
            ),
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => context
                        .read<NavigationService>()
                        .navigateToProductScreen(
                          ProductScreen.edit,
                          productId: product.id,
                        ),
                    color: const Color(0xFF667085),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _handleDelete(context),
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

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const AppConfirmationDialog(
        title: 'Delete Product',
        content: 'Are you sure you want to delete this product?',
        confirmText: 'Delete',
        cancelText: 'Cancel',
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await context.read<ProductProvider>().deleteProduct(product.id);

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
