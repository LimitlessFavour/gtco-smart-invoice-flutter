class DashboardTransaction {
  final int? id;
  final double amount;
  final String? paymentType;
  final String? paymentReference;
  final DateTime createdAt;
  final int? invoiceId;
  final int? clientId;
  final int? companyId;

  DashboardTransaction({
    this.id,
    required this.amount,
    this.paymentType,
    this.paymentReference,
    required this.createdAt,
    this.invoiceId,
    this.clientId,
    this.companyId,
  });

  factory DashboardTransaction.fromJson(Map<String, dynamic> json) {
    return DashboardTransaction(
      id: json['id'],
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      paymentType: json['paymentType'],
      paymentReference: json['paymentReference'],
      createdAt: DateTime.parse(json['createdAt']),
      invoiceId: json['invoiceId'],
      clientId: json['clientId'],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'paymentType': paymentType,
      'paymentReference': paymentReference,
      'createdAt': createdAt.toIso8601String(),
      'invoiceId': invoiceId,
      'clientId': clientId,
      'companyId': companyId,
    };
  }
}

class DashboardAnalytics {
  final List<DashboardTransaction> paymentsTimeline;
  final List<PaymentsByMonth> invoicesTimeline;
  final InvoiceStats invoiceStats;
  final List<TopClient> topPayingClients;
  final List<TopProduct> topSellingProducts;
  final List<DashboardActivity> activities;

  DashboardAnalytics({
    required this.paymentsTimeline,
    required this.invoicesTimeline,
    required this.invoiceStats,
    required this.topPayingClients,
    required this.topSellingProducts,
    required this.activities,
  });

  DashboardAnalytics copyWith({
    List<DashboardTransaction>? paymentsTimeline,
    List<PaymentsByMonth>? invoicesTimeline,
    InvoiceStats? invoiceStats,
    List<TopClient>? topPayingClients,
    List<TopProduct>? topSellingProducts,
    List<DashboardActivity>? activities,
  }) {
    return DashboardAnalytics(
      paymentsTimeline: paymentsTimeline ?? this.paymentsTimeline,
      invoicesTimeline: invoicesTimeline ?? this.invoicesTimeline,
      invoiceStats: invoiceStats ?? this.invoiceStats,
      topPayingClients: topPayingClients ?? this.topPayingClients,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      activities: activities ?? this.activities,
    );
  }

  factory DashboardAnalytics.fromJson(Map<String, dynamic> json) {
    return DashboardAnalytics(
      paymentsTimeline: (json['paymentsTimeline'] as List?)
              ?.map((e) => DashboardTransaction.fromJson(e))
              .toList() ??
          [],
      invoicesTimeline: (json['invoicesTimeline'] as List?)
              ?.map((e) => PaymentsByMonth.fromJson(e))
              .toList() ??
          [],
      invoiceStats: InvoiceStats.fromJson(json['invoiceStats'] ?? {}),
      topPayingClients: (json['topPayingClients'] as List?)
              ?.map((e) => TopClient.fromJson(e))
              .toList() ??
          [],
      topSellingProducts: (json['topSellingProducts'] as List?)
              ?.map((e) => TopProduct.fromJson(e))
              .toList() ??
          [],
      activities: (json['activities'] as List?)
              ?.map((e) => DashboardActivity.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentsTimeline': paymentsTimeline.map((e) => e.toJson()).toList(),
      'invoicesTimeline': invoicesTimeline.map((e) => e.toJson()).toList(),
      'invoiceStats': invoiceStats.toJson(),
      'topPayingClients': topPayingClients.map((e) => e.toJson()).toList(),
      'topSellingProducts': topSellingProducts.map((e) => e.toJson()).toList(),
      'activities': activities.map((e) => e.toJson()).toList(),
    };
  }
}

class PaymentsByMonth {
  final String month;
  final double amount;

  PaymentsByMonth({
    required this.month,
    required this.amount,
  });

  factory PaymentsByMonth.fromJson(Map<String, dynamic> json) {
    return PaymentsByMonth(
      month: json['month'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'amount': amount,
    };
  }
}

class InvoiceStats {
  final double totalInvoiced;
  final double paid;
  final double unpaid;
  final double drafted;
  final double totalAmount;

  InvoiceStats({
    required this.totalInvoiced,
    required this.paid,
    required this.unpaid,
    required this.drafted,
    required this.totalAmount,
  });

  factory InvoiceStats.fromJson(Map<String, dynamic> json) {
    return InvoiceStats(
      totalInvoiced: json['totalInvoiced'] != null
          ? double.parse(json['totalInvoiced'].toString())
          : 0,
      paid: double.parse(json['paid'].toString()),
      unpaid: double.parse(json['unpaid'].toString()),
      drafted: double.parse(json['drafted'].toString()),
      totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'totalInvoiced': totalInvoiced,
      'paid': paid,
      'unpaid': unpaid,
      'drafted': drafted,
      'totalAmount': totalAmount,
    };
  }
}

class TopClient {
  final String firstName;
  final String lastName;
  final double totalPaid;

  TopClient({
    required this.firstName,
    required this.lastName,
    required this.totalPaid,
  });

  factory TopClient.fromJson(Map<String, dynamic> json) {
    return TopClient(
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      totalPaid: double.tryParse(json['totalPaid']?.toString() ?? '0') ?? 0,
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'totalPaid': totalPaid,
    };
  }

  String get fullName => '$firstName $lastName';
}

class TopProduct {
  final String name;
  final double totalAmount;

  TopProduct({
    required this.name,
    required this.totalAmount,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      name: json['name'],
      totalAmount: double.parse(json['totalAmount']),
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalAmount': totalAmount,
    };
  }
}

class DashboardActivity {
  final int id;
  final String activity;
  final String entityType;
  final String entityId;
  final Map<String, dynamic>? metadata;
  final String date;

  DashboardActivity({
    required this.id,
    required this.activity,
    required this.entityType,
    required this.entityId,
    this.metadata,
    required this.date,
  });

  factory DashboardActivity.fromJson(Map<String, dynamic> json) {
    return DashboardActivity(
      id: json['id'],
      activity: json['activity'],
      entityType: json['entityType'],
      entityId: json['entityId'],
      metadata: json['metadata'],
      date: json['date'],
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity,
      'entityType': entityType,
      'entityId': entityId,
      'metadata': metadata,
      'date': date,
    };
  }
}
