import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;
  bool _isLoading = false;
  String? _error;
  List<Product> _products = [];
  String _searchQuery = '';

  ProductProvider(this._repository) {
    loadProducts();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get products => _filterProducts();
  bool get hasProducts => _products.isNotEmpty;

  List<Product> _filterProducts() {
    if (_searchQuery.isEmpty) return _products;
    return _products
        .where((product) =>
            product.productName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product.sku.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      _products = await _repository.getProducts();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createProduct(Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repository.createProduct(product);

      if (result) {
        _products.insert(0, product);
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

  Future<bool> updateProduct(Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repository.updateProduct(product);

      if (result) {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product;
        }
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
