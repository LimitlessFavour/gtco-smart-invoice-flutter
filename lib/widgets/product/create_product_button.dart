import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../common/app_text.dart';
import '../dialogs/confirmation_dialog.dart';
import '../dialogs/success_dialog.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../services/navigation_service.dart';

class ProductActionButton extends StatelessWidget {
  final bool isEdit;
  final Map<String, dynamic> formData;
  final VoidCallback? onCancel;

  const ProductActionButton({
    super.key,
    this.isEdit = false,
    required this.formData,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showConfirmation(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              isEdit ? 'Save Changes' : 'Save Product',
              color: Colors.white,
              weight: FontWeight.w500,
            ),
            const Gap(4),
            const Icon(Icons.check, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: isEdit ? 'Update Product' : 'Create Product',
        message: isEdit
            ? 'Are you sure you want to update this product?'
            : 'Are you sure you want to create this product?',
        confirmText: isEdit ? 'Update' : 'Create',
        onConfirm: () => _handleSubmit(context),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final provider = context.read<ProductProvider>();
    final navigationService = context.read<NavigationService>();

    final product = Product(
      id: isEdit
          ? formData['id']
          : DateTime.now().millisecondsSinceEpoch.toString(),
      companyId: '1',
      productName: formData['productName'],
      description: formData['description'] ?? '',
      price: double.parse(formData['price'].toString()),
      sku: formData['sku'] ?? 'SKU-${DateTime.now().millisecondsSinceEpoch}',
      quantity: int.parse(formData['quantity']?.toString() ?? '0'),
      image: formData['image'],
      createdAt:
          isEdit ? DateTime.parse(formData['createdAt']) : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = isEdit
        ? await provider.updateProduct(product)
        : await provider.createProduct(product);

    if (success && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SuccessDialog(
          message: isEdit
              ? 'Product has been updated successfully'
              : 'Product has been created successfully',
        ),
      );

      if (context.mounted) {
        navigationService.navigateToProductScreen(ProductScreen.list);
      }
    }
  }
}
