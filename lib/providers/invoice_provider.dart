import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/widgets/invoice/invoice_filter_dialog.dart';
import 'dart:math';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../models/client.dart';
import '../models/product.dart';
import '../models/product_enums.dart';
import '../repositories/invoice_repository.dart';
import '../models/dtos/create_invoice_dto.dart';
import '../services/logger_service.dart';
import '../providers/auth_provider.dart';
import '../models/invoice_list_stats.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceRepository _repository;
  final AuthProvider _authProvider;
  bool _isLoading = false;
  String? _error;
  List<Invoice> _invoices = [];

  // Add these properties at the top of the class
  List<Invoice> _filteredInvoices = [];
  String _searchQuery = '';
  String _currentFilter = 'All invoices';
  String _currentSort = 'Newest First';

  // Form State for Create/Edit
  String? _currentInvoiceNumber;
  DateTime? _dueDate;
  Client? _selectedClient;
  final List<InvoiceItem> _items = [];
  InvoiceListStats? _stats;

  VatCategory _selectedVat = VatCategory.none;

  FilterCriteria _filterCriteria = FilterCriteria();
  final List<String> sortOptions = [
    'Newest First',
    'Oldest First',
    'Highest Amount',
    'Lowest Amount',
    'Due Soonest',
    'Due Latest',
  ];

  // Add new field for stats
  InvoiceProvider(this._repository, this._authProvider) {
    _currentInvoiceNumber = _generateInvoiceNumber();
    loadInvoices();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Invoice> get invoices => _filteredInvoices.isEmpty &&
          _searchQuery.isEmpty &&
          _currentFilter == 'All invoices'
      ? _invoices
      : _filteredInvoices;
  bool get hasInvoices => _invoices.isNotEmpty;

  // Form State Getters
  String get currentInvoiceNumber =>
      _currentInvoiceNumber ?? _generateInvoiceNumber();
  Client? get selectedClient => _selectedClient;
  List<InvoiceItem> get items => _items;
  VatCategory get selectedVat => _selectedVat;
  DateTime? get dueDate => _dueDate;

  // Computed values
  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);
  double get vatAmount => subtotal * (_selectedVat.value / 100);
  double get total => subtotal + vatAmount;

  // Static methods
  static String _generateInvoiceNumber() {
    final random = Random();
    final number = random.nextInt(999) + 1;
    return 'INV-${number.toString().padLeft(3, '0')}';
  }

  // Form Methods
  void setDueDate(DateTime date) {
    _dueDate = date;
    notifyListeners();
  }

  void setSelectedClient(Client client) {
    _selectedClient = client;
    notifyListeners();
  }

  void setVatCategory(VatCategory category) {
    _selectedVat = category;
    notifyListeners();
  }

  void addItem(Product product) {
    final existingIndex =
        _items.indexWhere((item) => item.productId.toString() == product.id);

    if (existingIndex != -1) {
      final updatedItem = _items[existingIndex];
      updatedItem.quantity++;
    } else {
      _items.add(InvoiceItem.fromProduct(product));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId.toString() == productId);
    notifyListeners();
  }

  void updateItemQuantity(String productId, int quantity) {
    if (quantity > 0) {
      final item =
          _items.firstWhere((item) => item.productId.toString() == productId);
      item.quantity = quantity;
      notifyListeners();
    }
  }

  void clearForm() {
    _currentInvoiceNumber = _generateInvoiceNumber();
    _dueDate = null;
    _selectedClient = null;
    _items.clear();
    _selectedVat = VatCategory.none;
    notifyListeners();
  }

  // API Methods
  Future<void> loadInvoices() async {
    try {
      _isLoading = true;
      notifyListeners();

      print('not yet found: ${_invoices.length}');
      print('not yet found: ${_stats}');

      final response = await _repository.getInvoices();
      _invoices = response.data;
      _stats = response.stats;

      print('our invoices: ${_invoices.length}');
      print('our stats: ${_stats}');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      //log the error
      LoggerService.debug(
          'eroror has occvured load invoices: ${_error.toString()}');

      notifyListeners();
    }
  }

  Future<Invoice> createInvoice() async {
    if (!isValid) {
      throw Exception('Please fill in all required fields');
    }

    final user = _authProvider.user;
    if (user == null || user.company?.id == null) {
      throw Exception('User company information not found');
    }

    try {
      _isLoading = true;
      notifyListeners();

      final dto = CreateInvoiceDto(
        clientId: int.parse(_selectedClient!.id),
        companyId: int.parse(user.company!.id),
        dueDate: _dueDate!,
        items: _items
            .map((item) => CreateInvoiceItemDto(
                  productId: item.productId,
                  quantity: item.quantity,
                ))
            .toList(),
      );

      LoggerService.debug('Creating invoice with DTO: ${dto.toJson()}');
      final invoice = await _repository.createInvoice(dto);

      // Add to local list
      _invoices.insert(0, invoice);

      _isLoading = false;
      notifyListeners();

      return invoice;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Invoice> createDraftInvoice() async {
    if (!isValid) {
      throw Exception('Please fill in all required fields');
    }

    final user = _authProvider.user;
    if (user == null || user.company?.id == null) {
      throw Exception('User company information not found');
    }

    try {
      _isLoading = true;
      notifyListeners();

      final dto = CreateInvoiceDto(
        clientId: int.parse(_selectedClient!.id),
        companyId: int.parse(user.company!.id),
        dueDate: _dueDate!,
        items: _items
            .map((item) => CreateInvoiceItemDto(
                  productId: item.productId,
                  quantity: item.quantity,
                ))
            .toList(),
      );

      LoggerService.debug('Creating draft invoice with DTO: ${dto.toJson()}');
      final invoice = await _repository.createDraftInvoice(dto);

      // Add to local list
      _invoices.insert(0, invoice);

      _isLoading = false;
      notifyListeners();

      return invoice;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  bool get isValid {
    return _selectedClient != null && _items.isNotEmpty && _dueDate != null;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void createClear() {
    _dueDate = null;
    _selectedClient = null;
    _items.clear();
    _selectedVat = VatCategory.none;
    notifyListeners();
  }

  // Add these methods
  void searchInvoices(String query) {
    _searchQuery = query.toLowerCase();
    _filterAndSortInvoices();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    _filterAndSortInvoices();
  }

  void setSortOption(String sort) {
    _currentSort = sort;
    _filterAndSortInvoices();
  }

  void setFilterCriteria(FilterCriteria criteria) {
    _filterCriteria = criteria;
    _filterAndSortInvoices();
  }

  void _filterAndSortInvoices() {
    _filteredInvoices = List.from(_invoices);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      _filteredInvoices = _filteredInvoices
          .where((invoice) =>
              invoice.invoiceNumber.toLowerCase().contains(_searchQuery) ||
              invoice.client.fullName.toLowerCase().contains(_searchQuery))
          .toList();
    }

    // Apply quick filter tabs
    if (_currentFilter != 'All invoices') {
      _filteredInvoices = _filteredInvoices
          .where((invoice) =>
              invoice.status.toLowerCase() == _currentFilter.toLowerCase())
          .toList();
    }

    // Apply advanced filter criteria
    if (!_filterCriteria.isEmpty) {
      _filteredInvoices = _filteredInvoices.where((invoice) {
        if (_filterCriteria.startDate != null &&
            invoice.createdAt.isBefore(_filterCriteria.startDate!)) {
          return false;
        }
        if (_filterCriteria.endDate != null &&
            invoice.createdAt.isAfter(_filterCriteria.endDate!)) {
          return false;
        }
        if (_filterCriteria.status != null &&
            invoice.status.toLowerCase() !=
                _filterCriteria.status!.toLowerCase()) {
          return false;
        }
        if (_filterCriteria.minAmount != null &&
            invoice.totalAmount < _filterCriteria.minAmount!) {
          return false;
        }
        if (_filterCriteria.maxAmount != null &&
            invoice.totalAmount > _filterCriteria.maxAmount!) {
          return false;
        }
        return true;
      }).toList();
    }

    // Apply sorting
    switch (_currentSort) {
      case 'Due Soonest':
        _filteredInvoices.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case 'Due Latest':
        _filteredInvoices.sort((a, b) => b.dueDate.compareTo(a.dueDate));
        break;
      case 'Newest First':
        _filteredInvoices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Oldest First':
        _filteredInvoices.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Highest Amount':
        _filteredInvoices
            .sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
        break;
      case 'Lowest Amount':
        _filteredInvoices
            .sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
        break;
    }

    notifyListeners();
  }

  int getFilterCount(String filter) {
    if (filter == 'All invoices') return _invoices.length;
    return _invoices
        .where(
            (invoice) => invoice.status.toLowerCase() == filter.toLowerCase())
        .length;
  }

  FilterCriteria get filterCriteria => _filterCriteria;

  List<Invoice> get filteredInvoices => _filteredInvoices.isEmpty &&
          _searchQuery.isEmpty &&
          _currentFilter == 'All invoices' &&
          _filterCriteria.isEmpty
      ? _invoices
      : _filteredInvoices;

  // Add getter for stats
  InvoiceListStats? get stats => _stats;
}
