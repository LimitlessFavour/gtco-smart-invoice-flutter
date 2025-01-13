import 'package:flutter/material.dart';
import '../models/dashboard_analytics.dart';
import '../repositories/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository;
  bool _isLoading = false;
  String? _error;
  DashboardAnalytics? _analytics;
  String _paymentsTimeline = 'LAST_9_MONTHS';
  String _invoicesTimeline = 'LAST_6_MONTHS';
  bool _shouldAnimatePayments = false;
  bool _shouldAnimateInvoices = false;
  bool _isFirstLoad = true;
  bool _initialLoadComplete = false;

  DashboardProvider(this._repository) {
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
    try {
      _isLoading = true;
      notifyListeners();

      final paymentsData = await _repository.getPaymentsAnalytics(_paymentsTimeline);
      final invoicesData = await _repository.getInvoiceAnalytics(_invoicesTimeline);
      
      _analytics = DashboardAnalytics(
        paymentsTimeline: paymentsData,
        invoiceStats: invoicesData,
        topPayingClients: [], 
        topSellingProducts: [], 
      );

      _isLoading = false;
      _shouldAnimatePayments = true;
      _shouldAnimateInvoices = true;
      _initialLoadComplete = true;
      notifyListeners();

      await _loadTopLists();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePaymentsTimeline(String timeline) async {
    if (_paymentsTimeline != timeline) {
      _paymentsTimeline = timeline;
      _shouldAnimatePayments = true;
      await _loadPaymentsData();
      _shouldAnimatePayments = false;
    }
  }

  Future<void> updateInvoicesTimeline(String timeline) async {
    if (_invoicesTimeline != timeline) {
      _invoicesTimeline = timeline;
      _shouldAnimateInvoices = true;
      await _loadInvoiceData();
      _shouldAnimateInvoices = false;
    }
  }

  Future<void> _loadPaymentsData() async {
    try {
      final paymentsData =
          await _repository.getPaymentsAnalytics(_paymentsTimeline);
      _analytics = _analytics?.copyWith(paymentsTimeline: paymentsData);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadInvoiceData() async {
    try {
      final invoicesData =
          await _repository.getInvoiceAnalytics(_invoicesTimeline);
      _analytics = _analytics?.copyWith(invoiceStats: invoicesData);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadTopLists() async {
    // Load top lists with delay for animation
    await Future.delayed(const Duration(milliseconds: 500));
    final topClients = await _repository.getTopClients();
    _analytics = _analytics?.copyWith(topPayingClients: topClients);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    final topProducts = await _repository.getTopProducts();
    _analytics = _analytics?.copyWith(topSellingProducts: topProducts);
    notifyListeners();
  }
}
