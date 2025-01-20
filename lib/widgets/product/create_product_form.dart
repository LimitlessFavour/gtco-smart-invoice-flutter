import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/product_enums.dart';
import 'package:gtco_smart_invoice_flutter/providers/product_provider.dart';
import 'package:gtco_smart_invoice_flutter/widgets/product/create_product_button.dart';
import 'package:provider/provider.dart';
import '../common/app_text.dart';
import '../common/image_upload.dart';

class CreateProductForm extends StatefulWidget {
  final bool isEdit;
  final String? productId;
  final VoidCallback onCancel;

  const CreateProductForm({
    super.key,
    this.isEdit = false,
    this.productId,
    required this.onCancel,
  });

  @override
  State<CreateProductForm> createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _imageUploadKey = GlobalKey<ImageUploadState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  ProductCategory _selectedCategory = ProductCategory.Other;
  VatCategory _selectedVatCategory = VatCategory.none;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _maybeLoadProductData();
  }

  @override
  void didUpdateWidget(CreateProductForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('=== didUpdateWidget ===');
    debugPrint('oldIsEdit: ${oldWidget.isEdit}, newIsEdit: ${widget.isEdit}');
    debugPrint(
        'oldProductId: ${oldWidget.productId}, newProductId: ${widget.productId}');

    if (widget.isEdit &&
        widget.productId != null &&
        (oldWidget.productId != widget.productId || !oldWidget.isEdit)) {
      _maybeLoadProductData();
    }
  }

  void _maybeLoadProductData() {
    debugPrint('=== _maybeLoadProductData ===');
    debugPrint('isEdit: ${widget.isEdit}');
    debugPrint('productId: ${widget.productId}');

    if (widget.isEdit && widget.productId != null) {
      debugPrint('Calling _loadProductData...');
      _loadProductData();
    }
  }

  Future<void> _loadProductData() async {
    debugPrint('=== Starting _loadProductData ===');
    try {
      debugPrint('Fetching product with ID: ${widget.productId}');
      final provider = context.read<ProductProvider>();
      final product = await provider.getProductById(widget.productId!);
      debugPrint('Product fetched: ${product}');

      if (product != null) {
        debugPrint('Updating form fields...');
        setState(() {
          _nameController.text = product.productName;
          _descriptionController.text = product.description;
          _priceController.text = product.price.toString();
          _quantityController.text = product.defaultQuantity.toString();
          _selectedCategory = ProductCategory.values.firstWhere(
            (c) => c.name == product.category,
            orElse: () => ProductCategory.Other,
          );
          _selectedVatCategory = VatCategory.fromValue(
            product.vatCategory is num
                ? product.vatCategory as num
                : double.parse(
                    product.vatCategory.toString().replaceAll('%', '')),
          );
          _selectedImagePath = product.image;
        });
        debugPrint('Form fields updated successfully');
      }
    } catch (e) {
      debugPrint('Error in _loadProductData: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load product: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.text = '1';
    setState(() {
      _selectedCategory = ProductCategory.Other;
      _selectedVatCategory = VatCategory.none;
      _selectedImagePath = null;
    });
    _imageUploadKey.currentState?.clearImage();
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
                  onPressed: () {
                    _clearForm();
                    widget.onCancel();
                  },
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
                          onPressed: () {
                            _clearForm();
                            widget.onCancel();
                          },
                          child: const Text('Cancel'),
                        ),
                        const Gap(16),
                        ProductActionButton(
                          isEdit: widget.isEdit,
                          productId: widget.productId,
                          formKey: _formKey,
                          formData: {
                            'productName': _nameController.text,
                            'description': _descriptionController.text,
                            'category': _selectedCategory,
                            'price': _priceController.text,
                            'quantity': _quantityController.text,
                            'vatCategory': _selectedVatCategory,
                            'image': _selectedImagePath,
                          },
                          onCancel: () {
                            _clearForm();
                            widget.onCancel();
                          },
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

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Category',
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        DropdownButtonFormField<ProductCategory>(
          value: _selectedCategory,
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
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVatDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'VAT Category',
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        DropdownButtonFormField<VatCategory>(
          value: _selectedVatCategory,
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
    return ImageUpload(
      key: _imageUploadKey,
      onImageSelected: (String? path) {
        setState(() {
          _selectedImagePath = path;
        });
      },
      isMobile: false,
    );
  }
}
