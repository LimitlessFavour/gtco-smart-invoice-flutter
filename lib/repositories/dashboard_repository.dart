import '../models/dashboard_analytics.dart';
import '../services/dio_client.dart';
import '../services/logger_service.dart';

class DashboardRepository {
  final DioClient _dioClient;

  DashboardRepository(this._dioClient);

  Future<DashboardAnalytics> getDashboardData(int companyId) async {
    try {
      LoggerService.debug('Fetching dashboard data', {'companyId': companyId});

      final response = await _dioClient.get('/analytics/dashboard');
      // final response = await _dioClient.get('/analytics/dashboard/$companyId');

      if (response.statusCode != 200) {
        throw Exception(
          response.data?['message'] ?? 'Failed to fetch dashboard data',
        );
      }

      final data = response.data;
      if (data == null) {
        throw Exception('No data received from server');
      }

      return DashboardAnalytics(
        paymentsTimeline: _parsePaymentsTimeline(data['paymentsTimeline']),
        invoiceStats: _parseInvoiceStats(data['invoiceStats']),
        topPayingClients: _parseTopClients(data['topPayingClients']),
        topSellingProducts: _parseTopProducts(data['topSellingProducts']),
        activities: _parseActivities(data['activities']),
      );
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to fetch dashboard data',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  List<PaymentsByMonth> _parsePaymentsTimeline(dynamic data) {
    if (data == null) return [];

    try {
      return (data as List).map((p) {
        return PaymentsByMonth(
          month: p['month']?.toString() ?? '', // Keep as string, no parsing
          amount: double.tryParse(p['amount']?.toString() ?? '0') ?? 0,
        );
      }).toList();
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to parse payments timeline',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  InvoiceStats _parseInvoiceStats(dynamic data) {
    if (data == null) {
      return InvoiceStats(
        totalInvoiced: 0,
        paid: 0,
        unpaid: 0,
        drafted: 0,
        totalAmount: 0,
      );
    }

    try {
      return InvoiceStats.fromJson(data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to parse invoice stats',
        error: e,
        stackTrace: stackTrace,
      );
      return InvoiceStats(
        totalInvoiced: 0,
        paid: 0,
        unpaid: 0,
        drafted: 0,
        totalAmount: 0,
      );
    }
  }

  List<TopClient> _parseTopClients(dynamic data) {
    if (data == null) return [];

    try {
      return (data as List).map((c) => TopClient.fromJson(c)).toList();
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to parse top clients',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  List<TopProduct> _parseTopProducts(dynamic data) {
    if (data == null) return [];

    try {
      return (data as List).map((p) {
        return TopProduct(
          name: p['name']?.toString() ?? '',
          totalAmount:
              double.tryParse(p['totalAmount']?.toString() ?? '0') ?? 0,
        );
      }).toList();
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to parse top products',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  List<DashboardActivity> _parseActivities(dynamic data) {
    if (data == null) return [];

    try {
      return (data as List).map((a) {
        return DashboardActivity(
          id: int.tryParse(a['id']?.toString() ?? '0') ?? 0,
          activity: a['activity']?.toString() ?? '',
          entityType: a['entityType']?.toString() ?? '',
          entityId: a['entityId']?.toString() ?? '',
          metadata: a['metadata'] as Map<String, dynamic>?,
          date: a['date']?.toString() ?? DateTime.now().toIso8601String(),
        );
      }).toList();
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to parse activities',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }
}
