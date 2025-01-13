import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/common/app_text.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/common/loading_overlay.dart';
import '../../../widgets/dialogs/success_dialog.dart';
import 'package:provider/provider.dart';

class ProductMobileForm extends StatefulWidget {
  final bool isEdit;

  const ProductMobileForm({
    super.key,
    this.isEdit = false,
  });

  @override
  State<ProductMobileForm> createState() => _ProductMobileFormState();
}

class _ProductMobileFormState extends State<ProductMobileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  String? _selectedVatCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
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
                _buildTextField(
                  label: 'Category',
                  controller: _categoryController,
                ),
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
                _buildDropdown(
                  label: 'VAT Category',
                  value: _selectedVatCategory,
                  items: const ['None', '7.5%', '5%'],
                  onChanged: (value) {
                    setState(() {
                      _selectedVatCategory = value;
                    });
                  },
                ),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Upload Product Image',
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement product creation/update logic
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const SuccessDialog(
            message: 'Product created successfully',
          ),
        );
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }
  }
}
