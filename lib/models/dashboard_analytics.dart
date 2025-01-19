class DashboardAnalytics {
  final List<PaymentsByMonth> paymentsTimeline;
  final InvoiceStats invoiceStats;
  final List<TopClient> topPayingClients;
  final List<TopProduct> topSellingProducts;
  final List<DashboardActivity> activities;

  DashboardAnalytics({
    required this.paymentsTimeline,
    required this.invoiceStats,
    required this.topPayingClients,
    required this.topSellingProducts,
    required this.activities,
  });

  DashboardAnalytics copyWith({
    List<PaymentsByMonth>? paymentsTimeline,
    InvoiceStats? invoiceStats,
    List<TopClient>? topPayingClients,
    List<TopProduct>? topSellingProducts,
    List<DashboardActivity>? activities,
  }) {
    return DashboardAnalytics(
      paymentsTimeline: paymentsTimeline ?? this.paymentsTimeline,
      invoiceStats: invoiceStats ?? this.invoiceStats,
      topPayingClients: topPayingClients ?? this.topPayingClients,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      activities: activities ?? this.activities,
    );
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'paymentsTimeline': paymentsTimeline.map((e) => e.toJson()).toList(),
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

  //to json
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
