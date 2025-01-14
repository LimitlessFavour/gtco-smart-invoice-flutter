class Product {
  final String id;
  final int companyId;
  final String productName;
  final String description;
  final double price;
  final String sku;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int quantity;
  final String category;
  final String vatCategory;
  final int defaultQuantity;

  Product({
    required this.id,
    required this.companyId,
    required this.productName,
    required this.description,
    required this.price,
    required this.sku,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.quantity,
    required this.category,
    required this.vatCategory,
    required this.defaultQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Convert vatCategory to double for consistent handling
    num vatValue;
    var rawVat = json['vatCategory'];
    if (rawVat is int) {
      vatValue = rawVat.toDouble();
    } else if (rawVat is String) {
      vatValue = double.parse(rawVat.replaceAll('%', ''));
    } else {
      vatValue = 0;
    }

    return Product(
      id: json['id'].toString(),
      companyId: json['companyId'] as int,
      productName: json['productName'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'].toString()),
      sku: json['sku'] as String,
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      quantity: json['defaultQuantity'] as int,
      category: json['category'] as String,
      vatCategory: '${vatValue.toString()}%',
      defaultQuantity: json['defaultQuantity'] as int,
    );
  }
}
