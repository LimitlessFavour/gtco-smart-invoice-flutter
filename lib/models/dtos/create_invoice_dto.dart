class CreateInvoiceDto {
  final int clientId;
  final int companyId;
  final DateTime dueDate;
  final List<CreateInvoiceItemDto> items;

  CreateInvoiceDto({
    required this.clientId,
    required this.companyId,
    required this.dueDate,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'companyId': companyId,
      'dueDate': dueDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class CreateInvoiceItemDto {
  final int productId;
  final int quantity;

  CreateInvoiceItemDto({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}
