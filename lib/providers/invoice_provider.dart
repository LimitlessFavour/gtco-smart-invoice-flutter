import 'package:flutter/material.dart';
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

class InvoiceProvider extends ChangeNotifier {
  final InvoiceRepository _repository;
  final AuthProvider _authProvider;
  bool _isLoading = false;
  String? _error;
  List<Invoice> _invoices = [];


  // Form State for Create/Edit
  String? _currentInvoiceNumber;
  DateTime? _dueDate;
  Client? _selectedClient;
  final List<InvoiceItem> _items = [];
  VatCategory _selectedVat = VatCategory.none;

  InvoiceProvider(this._repository, this._authProvider) {
    _currentInvoiceNumber = _generateInvoiceNumber();
    loadInvoices();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Invoice> get invoices => _invoices;
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
      final item = _items.firstWhere((item) => item.productId.toString() == productId);
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

      _invoices = await _repository.getInvoices();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
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
}
