import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/product/create_product_button.dart';
import '../common/app_text.dart';

class CreateProductForm extends StatefulWidget {
  final bool isEdit;
  final VoidCallback onCancel;

  const CreateProductForm({
    super.key,
    this.isEdit = false,
    required this.onCancel,
  });

  @override
  State<CreateProductForm> createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  widget.isEdit ? 'Edit Product' : 'New Product',
                  size: 24,
                  weight: FontWeight.w600,
                ),
                IconButton(
                  onPressed: widget.onCancel,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // Form Fields
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
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
                  const Gap(24),
                  _buildImageUpload(),
                  // Actions
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: widget.onCancel,
                          child: const Text('Cancel'),
                        ),
                        const Gap(16),
                        ProductActionButton(
                          isEdit: widget.isEdit,
                          formData: {
                            'productName': _nameController.text,
                            'description': _descriptionController.text,
                            'category': _categoryController.text,
                            'price': _priceController.text,
                            'quantity': _quantityController.text,
                            'vatCategory': _selectedVatCategory,
                          },
                          onCancel: widget.onCancel,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
              borderRadius: BorderRadius.circular(8),
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
              borderRadius: BorderRadius.circular(8),
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
            borderRadius: BorderRadius.circular(8),
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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Handle form submission
      widget.onCancel();
    }
  }
}
