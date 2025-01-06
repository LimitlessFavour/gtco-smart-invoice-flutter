class InvoiceItem {
  final String id;
  final String invoiceId;
  final String productId;
  final int quantity;
  final double price;

  InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['invoice_item_id'].toString(),
      invoiceId: json['invoice_id'].toString(),
      productId: json['product_id'].toString(),
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
} 