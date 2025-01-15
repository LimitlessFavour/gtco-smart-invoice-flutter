import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/product_enums.dart';
import 'package:provider/provider.dart';

import '../../models/create_product.dart';
import '../../providers/product_provider.dart';
import '../../services/navigation_service.dart';
import '../common/app_text.dart';
import '../dialogs/success_dialog.dart';

class ProductActionButton extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic> formData;
  final VoidCallback? onCancel;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onSuccess;
  final String? productId;

  const ProductActionButton({
    super.key,
    this.isEdit = false,
    required this.formData,
    this.onCancel,
    required this.formKey,
    this.onSuccess,
    this.productId,
  });

  @override
  State<ProductActionButton> createState() => _ProductActionButtonState();
}

class _ProductActionButtonState extends State<ProductActionButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE04403),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  widget.isEdit ? 'Save Changes' : 'Create Product',
                  color: Colors.white,
                  weight: FontWeight.w500,
                ),
                const Gap(4),
                const Icon(Icons.check, color: Colors.white, size: 20),
              ],
            ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!widget.formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final provider = context.read<ProductProvider>();
      final navigationService = context.read<NavigationService>();

      final createProduct = CreateProduct(
        productName: widget.formData['productName'],
        description: widget.formData['description'] ?? '',
        category: widget.formData['category'] as ProductCategory,
        price: double.parse(widget.formData['price'].toString()),
        defaultQuantity:
            int.parse(widget.formData['quantity']?.toString() ?? '0'),
        vatCategory: widget.formData['vatCategory'] as VatCategory,
        image: widget.formData['image'],
      );

      final success = widget.isEdit
          ? await provider.updateProduct(
              id: widget.productId!,
              product: createProduct,
            )
          : await provider.createProduct(createProduct);

      if (success && context.mounted) {
        widget.onSuccess?.call();
        widget.onCancel?.call();
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SuccessDialog(
            message: widget.isEdit
                ? 'Product updated successfully'
                : 'Product created successfully',
          ),
        );
        if (context.mounted) {
          widget.onSuccess?.call();
          navigationService.navigateToProductScreen(ProductScreen.list);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: AppText(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
