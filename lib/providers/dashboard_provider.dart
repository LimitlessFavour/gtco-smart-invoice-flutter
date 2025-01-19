import 'package:flutter/material.dart';
import '../models/dashboard_analytics.dart';
import '../repositories/dashboard_repository.dart';
// import '../repositories/dummy_payments_repository.dart';
import '../services/logger_service.dart';
import '../providers/auth_provider.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository;
  // final DummyPaymentsRepository _dummyPayments;
  final AuthProvider _authProvider;

  bool _isLoading = false;
  String? _error;
  DashboardAnalytics? _analytics;
  String _paymentsTimeline = 'LAST_9_MONTHS';
  String _invoicesTimeline = 'LAST_6_MONTHS';
  bool _shouldAnimatePayments = false;
  bool _shouldAnimateInvoices = false;
  bool _initialLoadComplete = false;

  //  DashboardProvider(this._repository, this._authProvider)
  //     : _dummyPayments = DummyPaymentsRepository() {
  DashboardProvider(this._repository, this._authProvider) {
    loadDashboardData();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  DashboardAnalytics? get analytics => _analytics;
  String get paymentsTimeline => _paymentsTimeline;
  String get invoicesTimeline => _invoicesTimeline;
  bool get shouldAnimatePayments => _shouldAnimatePayments;
  bool get shouldAnimateInvoices => _shouldAnimateInvoices;
  bool get initialLoadComplete => _initialLoadComplete;

  Future<void> loadDashboardData() async {
    if (_authProvider.user?.company?.id == null) {
      _error = 'Company information not found';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final companyId = int.parse(_authProvider.user!.company!.id);

      // // Get dummy payments data
      // final paymentsData =
      //     await _dummyPayments.getPaymentsAnalytics(_paymentsTimeline);

      // // Get real dashboard data
      final dashboardData = await _repository.getDashboardData(companyId);
      //       _analytics = DashboardAnalytics(
      //   paymentsTimeline: paymentsData,
      //   invoiceStats: dashboardData.invoiceStats,
      //   topPayingClients: dashboardData.topPayingClients,
      //   topSellingProducts: dashboardData.topSellingProducts,
      //   activities: dashboardData.activities,
      // );

      _analytics = dashboardData;
      _isLoading = false;
      _shouldAnimatePayments = true;
      _shouldAnimateInvoices = true;
      _initialLoadComplete = true;
      _error = null;
      notifyListeners();
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to load dashboard data',
        error: e,
        stackTrace: stackTrace,
      );

      if (_analytics == null) {
        _error = 'Failed to load dashboard data';
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePaymentsTimeline(String timeline) async {
    if (_paymentsTimeline != timeline) {
      _paymentsTimeline = timeline;
      _shouldAnimatePayments = true;
      await loadDashboardData();
    }
  }

  Future<void> updateInvoicesTimeline(String timeline) async {
    if (_invoicesTimeline != timeline) {
      _invoicesTimeline = timeline;
      _shouldAnimateInvoices = true;
      await loadDashboardData();
    }
  }

  Future<void> refreshDashboard() async {
    _shouldAnimatePayments = true;
    _shouldAnimateInvoices = true;
    await loadDashboardData();
  }

  void onTabChanged() {
    if (_analytics != null) {
      _shouldAnimatePayments = true;
      _shouldAnimateInvoices = true;
      notifyListeners();
    }
  }

  void clearState() {
    _analytics = null;
    _error = null;
    _initialLoadComplete = false;
    notifyListeners();
  }
}
