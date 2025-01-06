class Product {
  final String id;
  final String companyId;
  final String productName;
  final String description;
  final double price;
  final String sku;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int quantity; // For tracking inventory

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
    this.quantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'].toString(),
      companyId: json['company_id'].toString(),
      productName: json['product_name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      sku: json['sku'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      quantity: json['quantity'] ?? 0,
    );
  }
} 