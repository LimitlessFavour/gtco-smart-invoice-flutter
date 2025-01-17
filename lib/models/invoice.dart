import 'package:gtco_smart_invoice_flutter/models/client.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice_item.dart';
import 'package:gtco_smart_invoice_flutter/models/company.dart';

class Invoice {
  final int id;
  final String invoiceNumber;
  final DateTime dueDate;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? paidAt;
  final String? paymentLink;
  final String? transactionRef;
  final String? squadTransactionRef;
  final List<InvoiceItem> items;
  final Client client;
  final Company company;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.dueDate,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.updatedAt,
    this.paidAt,
    this.paymentLink,
    this.transactionRef,
    this.squadTransactionRef,
    required this.items,
    required this.client,
    required this.company,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? 0,
      invoiceNumber: json['invoiceNumber'] ?? '',
      dueDate: DateTime.parse(json['dueDate'] ?? '2000-01-01'),
      status: json['status'] ?? '',
      // totalAmount: double.parse(json['totalAmount'].toString()),
      // totalAmount: double.tryParse(json['totalAmount']) ?? 0, // Fix here
      totalAmount: double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0,

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      paymentLink: json['paymentLink'] ?? '',
      transactionRef: json['transactionRef'] ?? '',
      squadTransactionRef: json['squadTransactionRef'] ?? '',
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item))
          .toList(),
      client: Client.fromJson(json['client']),
      company: Company.fromJson(json['company']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'paymentLink': paymentLink,
      'transactionRef': transactionRef,
      'squadTransactionRef': squadTransactionRef,
      'items': items.map((item) => item.toJson()).toList(),
      'client': client.toJson(),
      'company': company.toJson(),
    };
  }
}
