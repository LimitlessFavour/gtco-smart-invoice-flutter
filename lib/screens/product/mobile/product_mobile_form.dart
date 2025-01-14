import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/create_product.dart';
import 'package:gtco_smart_invoice_flutter/models/product_enums.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/image_upload.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/loading_overlay.dart';
import '../../../widgets/dialogs/success_dialog.dart';

class ProductMobileForm extends StatefulWidget {
  final bool isEdit;
  final String? productId;

  const ProductMobileForm({
    super.key,
    this.isEdit = false,
    this.productId,
  });

  @override
  State<ProductMobileForm> createState() => _ProductMobileFormState();
}

class _ProductMobileFormState extends State<ProductMobileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  ProductCategory _selectedCategory = ProductCategory.Other;
  VatCategory _selectedVatCategory = VatCategory.none;
  String? _selectedImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Product Name',
                  controller: _nameController,
                  isRequired: true,
                ),
                const Gap(16),
                _buildTextField(
                  label: 'Product Description',
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                const Gap(16),
                _buildCategoryDropdown(),
                const Gap(16),
                _buildTextField(
                  label: 'Price',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  prefixText: '₦ ',
                  isRequired: true,
                ),
                const Gap(16),
                _buildTextField(
                  label: 'Default Quantity',
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                ),
                const Gap(16),
                _buildVatDropdown(),
                const Gap(16),
                _buildImageUpload(),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE04403),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: AppText(
                      widget.isEdit ? 'Update Product' : 'Create Product',
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '$label${isRequired ? ' *' : ''}',
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixText: prefixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<ProductCategory>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: ProductCategory.values.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category.display),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value ?? ProductCategory.Other;
        });
      },
    );
  }

  Widget _buildVatDropdown() {
    return DropdownButtonFormField<VatCategory>(
      value: _selectedVatCategory,
      decoration: const InputDecoration(
        labelText: 'VAT Category',
        border: OutlineInputBorder(),
      ),
      items: VatCategory.values.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category.display),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedVatCategory = value ?? VatCategory.none;
        });
      },
    );
  }

  Widget _buildImageUpload() {
    return ImageUpload(
      onImageSelected: (String? imagePath) {
        // Handle the image path
        setState(() {
          _selectedImagePath = imagePath;
        });
      },
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProductProvider>();

      try {
        // Set loading state
        setState(() => provider.setLoading(true));

        final createProduct = CreateProduct(
          productName: _nameController.text,
          description: _descriptionController.text,
          category: _selectedCategory,
          price: double.parse(_priceController.text),
          defaultQuantity: int.parse(_quantityController.text),
          vatCategory: _selectedVatCategory,
          image: _selectedImagePath,
        );

        final success = widget.isEdit
            ? await provider.updateProduct(
                id: widget.productId ?? '',
                product: createProduct,
              )
            : await provider.createProduct(createProduct);

        if (success && context.mounted) {
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
            Navigator.pop(context);
          }
        }
      } finally {
        if (mounted) {
          provider.setLoading(false);
        }
      }
    }
  }
}
