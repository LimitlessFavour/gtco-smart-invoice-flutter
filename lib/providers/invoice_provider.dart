import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../repositories/invoice_repository.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceRepository _repository;
  bool _isLoading = false;
  String? _error;
  List<Invoice> _invoices = [];

  InvoiceProvider(this._repository) {
    // Load invoices when provider is initialized
    //TODO: Add it again....left out for testing purposes
    // loadInvoices();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Invoice> get invoices => _invoices;
  bool get hasInvoices => _invoices.isNotEmpty;

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

  Future<bool> sendInvoice(Invoice invoice) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repository.sendInvoice(invoice);

      if (result) {
        // Add the new invoice to the list
        _invoices.insert(0, invoice);
      }

      _isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
