import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/models/bulk_upload_state.dart';
import 'dart:io';
import 'dart:async';

import '../models/product.dart';
import '../models/create_product.dart';
import '../repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  BulkUploadState _bulkUploadState = BulkUploadState();
  Timer? _statusCheckTimer;

  ProductProvider(this._repository);

  List<Product> get products {
    final filtered = _products
        .where((product) => product.productName
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
    return filtered;
  }

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _repository.getProducts();
      print('Loaded products count: ${_products.length}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading products: $e');
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      // First check if the product exists in our local list
      final localProduct = _products.where((p) => p.id == id).firstOrNull;

      if (localProduct != null) {
        debugPrint('Product found in local cache: ${localProduct.productName}');
        return localProduct;
      }

      debugPrint('Product not found locally, fetching from API...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      final product = await _repository.getProductById(id);
      _isLoading = false;
      notifyListeners();
      return product;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> createProduct(CreateProduct product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newProduct = await _repository.createProduct(product);
      _products.add(newProduct);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct({
    required String id,
    required CreateProduct product,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedProduct = await _repository.updateProduct(
        id: id,
        product: product,
      );

      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.deleteProduct(id);
      _products.removeWhere((product) => product.id == id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  BulkUploadState get bulkUploadState => _bulkUploadState;

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> validateBulkUpload(File file) async {
    try {
      _bulkUploadState = BulkUploadState(status: BulkUploadStatus.validating);
      notifyListeners();

      final response = await _repository.validateBulkUpload(file);

      _bulkUploadState = BulkUploadState(
        status: BulkUploadStatus.validated,
        headers: List<String>.from(response['headers']),
        sampleData: List<Map<String, dynamic>>.from(response['sampleData']),
        totalRows: response['totalRows'],
      );
      notifyListeners();
    } catch (e) {
      _bulkUploadState = BulkUploadState(
        status: BulkUploadStatus.error,
        error: e.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> startBulkUpload({
    required File file,
    required Map<String, String> columnMapping,
  }) async {
    try {
      _bulkUploadState = _bulkUploadState.copyWith(
        status: BulkUploadStatus.uploading,
        columnMapping: columnMapping,
      );
      notifyListeners();

      final jobId = await _repository.startBulkUpload(
        file: file,
        columnMapping: columnMapping,
      );

      _bulkUploadState = _bulkUploadState.copyWith(jobId: jobId);
      notifyListeners();

      // Start polling for status
      _startStatusPolling();
    } catch (e) {
      _bulkUploadState = BulkUploadState(
        status: BulkUploadStatus.error,
        error: e.toString(),
      );
      notifyListeners();
    }
  }

  void _startStatusPolling() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_bulkUploadState.jobId == null) {
        timer.cancel();
        return;
      }

      try {
        final status =
            await _repository.getBulkUploadStatus(_bulkUploadState.jobId!);

        if (status['status'] == 'completed' || status['status'] == 'failed') {
          timer.cancel();

          if (status['status'] == 'completed') {
            await loadProducts(); // Refresh product list
          }

          _bulkUploadState = _bulkUploadState.copyWith(
            status: status['status'] == 'completed'
                ? BulkUploadStatus.completed
                : BulkUploadStatus.error,
            totalRows: status['totalRows'],
            processedRows: status['processedRows'],
            successCount: status['successCount'],
            errorCount: status['errorCount'],
          );
          notifyListeners();
        } else {
          // Update progress
          _bulkUploadState = _bulkUploadState.copyWith(
            processedRows: status['processedRows'],
            totalRows: status['totalRows'],
          );
          notifyListeners();
        }
      } catch (e) {
        timer.cancel();
        _bulkUploadState = BulkUploadState(
          status: BulkUploadStatus.error,
          error: e.toString(),
        );
        notifyListeners();
      }
    });
  }

  Future<List<String>> getBulkUploadErrors() async {
    if (_bulkUploadState.jobId == null) return [];

    try {
      return await _repository.getBulkUploadErrors(_bulkUploadState.jobId!);
    } catch (e) {
      return ['Failed to fetch errors: ${e.toString()}'];
    }
  }

  void resetBulkUploadState() {
    _statusCheckTimer?.cancel();
    _bulkUploadState = BulkUploadState();
    notifyListeners();
  }
}
