import 'invoice.dart';
import 'invoice_list_stats.dart';

class PaginatedInvoiceResponse {
  final List<Invoice> data;
  final int total;
  final int page;
  final int limit;
  final InvoiceListStats stats;

  PaginatedInvoiceResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.stats,
  });

factory PaginatedInvoiceResponse.fromJson(Map<String, dynamic> json) {
  return PaginatedInvoiceResponse(
    data: (json['data'] as List?)?.map((item) => Invoice.fromJson(item)).toList() ?? [],
    total: json['total'] ?? 0,
    page: json['page'] ?? 0,
    limit: json['limit'] ?? 0,
    stats: InvoiceListStats.fromJson(json['stats'] ?? {}),
  );
}
}
