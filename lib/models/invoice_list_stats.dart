class InvoiceListStats {
  final num overdueAmount;
  final num totalDraftedAmount;
  final num averagePaidTime;
  final num unpaidTotal;
  final int totalInvoicesSentToday;

  InvoiceListStats({
    required this.overdueAmount,
    required this.totalDraftedAmount,
    required this.averagePaidTime,
    required this.unpaidTotal,
    required this.totalInvoicesSentToday,
  });

  factory InvoiceListStats.fromJson(Map<String, dynamic> json) {
    return InvoiceListStats(
      overdueAmount: json['overdue_amount'] ?? 0,
      totalDraftedAmount: json['total_drafted_amount'] ?? 0,
      averagePaidTime: json['average_paid_time'] ?? 0,
      unpaidTotal: json['unpaid_total'] ?? 0,
      totalInvoicesSentToday: json['total_invoices_sent_today'] ?? 0,
    );
  }
}
