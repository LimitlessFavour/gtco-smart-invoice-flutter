import '../models/dashboard_analytics.dart';

class DashboardRepository {
  Future<List<PaymentsByMonth>> getPaymentsAnalytics(String timeline) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final now = DateTime.now();
    int dataPoints;

    switch (timeline) {
      case 'LAST_WEEK':
        dataPoints = 7;
        return List.generate(
          dataPoints,
          (index) => PaymentsByMonth(
            month: now.subtract(Duration(days: index)),
            amount: (dataPoints - index) * 100000.0,
          ),
        ).reversed.toList();

      case 'LAST_MONTH':
        dataPoints = 4; // 4 weeks
        return List.generate(
          dataPoints,
          (index) => PaymentsByMonth(
            month: now.subtract(Duration(days: 7 * index)),
            amount: (dataPoints - index) * 200000.0,
          ),
        ).reversed.toList();

      case 'LAST_3_MONTHS':
        dataPoints = 3;
        return List.generate(
          dataPoints,
          (index) => PaymentsByMonth(
            month: DateTime(now.year, now.month - index),
            amount: (dataPoints - index) * 300000.0,
          ),
        ).reversed.toList();

      case 'LAST_6_MONTHS':
        dataPoints = 6;
        return List.generate(
          dataPoints,
          (index) => PaymentsByMonth(
            month: DateTime(now.year, now.month - index),
            amount: (dataPoints - index) * 150000.0,
          ),
        ).reversed.toList();

      case 'LAST_9_MONTHS':
        dataPoints = 9;
        return List.generate(
          dataPoints,
          (index) => PaymentsByMonth(
            month: DateTime(now.year, now.month - index),
            amount: (dataPoints - index) * 100000.0,
          ),
        ).reversed.toList();

      case 'LAST_12_MONTHS':
      default:
        dataPoints = 12;
        return List.generate(
          dataPoints,
          (index) => PaymentsByMonth(
            month: DateTime(now.year, now.month - index),
            amount: (dataPoints - index) * 75000.0,
          ),
        ).reversed.toList();
    }
  }

  Future<InvoiceStats> getInvoiceAnalytics(String timeline) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock different data based on timeline
    switch (timeline) {
      case 'LAST_WEEK':
        return InvoiceStats(
          paid: 60,
          unpaid: 30,
          drafted: 10,
          totalAmount: 300000,
        );
      case 'LAST_MONTH':
        return InvoiceStats(
          paid: 50,
          unpaid: 40,
          drafted: 10,
          totalAmount: 400000,
        );
      case 'LAST_3_MONTHS':
        return InvoiceStats(
          paid: 45,
          unpaid: 45,
          drafted: 10,
          totalAmount: 450000,
        );
      default:
        return InvoiceStats(
          paid: 40,
          unpaid: 50,
          drafted: 10,
          totalAmount: 500000,
        );
    }
  }

  Future<List<TopClient>> getTopClients() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      4,
      (index) => TopClient(
        name: 'John Snow ${index + 1}',
        totalAmount: 260000.0 - (index * 50000),
      ),
    );
  }

  Future<List<TopProduct>> getTopProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      4,
      (index) => TopProduct(
        name: 'Bone Straight ${index + 1}',
        totalAmount: 260000.0 - (index * 40000),
      ),
    );
  }
}
