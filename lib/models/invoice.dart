import 'package:gtco_smart_invoice_flutter/models/client.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice_item.dart';

class Invoice {
  final String id;
  final String companyId;
  final String clientId;
  final String invoiceNumber;
  final DateTime dueDate;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<InvoiceItem> items;
  final Client client;

  Invoice({
    required this.id,
    required this.companyId,
    required this.clientId,
    required this.invoiceNumber,
    required this.dueDate,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.client,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['invoice_id'].toString(),
      companyId: json['company_id'].toString(),
      clientId: json['client_id'].toString(),
      invoiceNumber: json['invoice_number'],
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'],
      totalAmount: json['total_amount'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item))
          .toList(),
      client: Client.fromJson(json['client']),
    );
  }
}
