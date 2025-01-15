class DashboardAnalytics {
  final List<PaymentsByMonth> paymentsTimeline;
  final InvoiceStats invoiceStats;
  final List<TopClient> topPayingClients;
  final List<TopProduct> topSellingProducts;

  DashboardAnalytics({
    required this.paymentsTimeline,
    required this.invoiceStats,
    required this.topPayingClients,
    required this.topSellingProducts,
  });

  DashboardAnalytics copyWith({
    List<PaymentsByMonth>? paymentsTimeline,
    InvoiceStats? invoiceStats,
    List<TopClient>? topPayingClients,
    List<TopProduct>? topSellingProducts,
  }) {
    return DashboardAnalytics(
      paymentsTimeline: paymentsTimeline ?? this.paymentsTimeline,
      invoiceStats: invoiceStats ?? this.invoiceStats,
      topPayingClients: topPayingClients ?? this.topPayingClients,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
    );
  }
}

class PaymentsByMonth {
  final DateTime month;
  final double amount;

  PaymentsByMonth({
    required this.month,
    required this.amount,
  });
}

class InvoiceStats {
  final int paid;
  final int unpaid;
  final int drafted;
  final double totalAmount;

  InvoiceStats({
    required this.paid,
    required this.unpaid,
    required this.drafted,
    required this.totalAmount,
  });
}

class TopClient {
  final String name;
  final double totalAmount;

  TopClient({
    required this.name,
    required this.totalAmount,
  });
}

class TopProduct {
  final String name;
  final double totalAmount;

  TopProduct({
    required this.name,
    required this.totalAmount,
  });
}
