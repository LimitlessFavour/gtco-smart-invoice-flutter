import 'product_enums.dart';

class CreateProduct {
  final String productName;
  final String description;
  final ProductCategory category;
  final double price;
  final int defaultQuantity;
  final VatCategory vatCategory;
  final String? sku;
  final String? image;

  CreateProduct({
    required this.productName,
    required this.description,
    required this.category,
    required this.price,
    required this.defaultQuantity,
    required this.vatCategory,
    this.sku,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'description': description,
      'category': category.name,
      'price': price,
      'default_quantity': defaultQuantity,
      'vat_category': vatCategory.value,
      if (sku != null) 'sku': sku,
      if (image != null) 'image': image,
    };
  }
}
