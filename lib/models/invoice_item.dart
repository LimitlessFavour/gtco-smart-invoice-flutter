import 'package:gtco_smart_invoice_flutter/models/product.dart';

class InvoiceItem {
  final int id;
  final int invoiceId;
  final int productId;
  int quantity;
  final double price;
  final DateTime createdAt;
  final String? productName;
  final String? description;
  final String? sku;

  InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.createdAt,
    this.productName,
    this.description,
    this.sku,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      invoiceId: json['invoiceId'],
      productId: json['productId'],
      quantity: json['quantity'],
      price: double.tryParse(json['price']) ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      productName: json['productName'],
      description: json['description'],
      sku: json['sku'],
    );
  }

  factory InvoiceItem.fromProduct(Product product) {
    return InvoiceItem(
      id: 0,
      invoiceId: 0,
      productId: int.tryParse(product.id) ?? 0,
      quantity: 1,
      price: product.price,
      createdAt: DateTime.now(),
      productName: product.productName,
      description: product.description,
      sku: product.sku,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'productName': productName,
      'description': description,
      'sku': sku,
    };
  }

  double get total => quantity * price;
}
