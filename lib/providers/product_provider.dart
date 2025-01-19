import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:gtco_smart_invoice_flutter/models/bulk_upload_state.dart';

import '../models/create_product.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  BulkUploadState _bulkUploadState = BulkUploadState();
  Timer? _pollTimer;

  ProductProvider(this._repository) {
    loadProducts();
  }

  List<Product> get products {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      final query = _searchQuery.toLowerCase();
      return product.productName.toLowerCase().contains(query) ||
          (product.description?.toLowerCase().contains(query) ?? false) ||
          (product.sku?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;

  //method to load products if empty

  Future<void> loadProductsIfEmpty() async {
    if (_products.isEmpty) {
      await loadProducts();
    }
  }

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
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> validateBulkUpload(dynamic file) async {
    try {
      _setBulkUploadState(BulkUploadState(status: BulkUploadStatus.validating));

      Map<String, dynamic> response;
      if (kIsWeb && file is PlatformFile) {
        // Handle web file
        if (file.bytes == null) {
          throw Exception('No file data available');
        }
        response =
            await _repository.validateBulkUploadWeb(file.bytes!, file.name);
      } else if (file is File) {
        // Handle mobile file
        response = await _repository.validateBulkUpload(file);
      } else {
        throw Exception('Invalid file type');
      }

      _setBulkUploadState(
        BulkUploadState(
          status: BulkUploadStatus.validated,
          headers: List<String>.from(response['headers'] ?? []),
          sampleData:
              List<Map<String, dynamic>>.from(response['sampleData'] ?? []),
        ),
      );
    } catch (e) {
      _setBulkUploadState(
        BulkUploadState(
          status: BulkUploadStatus.error,
          error: e.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<void> startBulkUpload({
    required dynamic file,
    required Map<String, String> columnMapping,
  }) async {
    try {
      _setBulkUploadState(BulkUploadState(status: BulkUploadStatus.uploading));

      String jobId;
      if (kIsWeb && file is PlatformFile) {
        // Handle web file
        if (file.bytes == null) {
          throw Exception('No file data available');
        }
        jobId = await _repository.startBulkUploadWeb(
          bytes: file.bytes!,
          filename: file.name,
          columnMapping: columnMapping,
        );
      } else if (file is File) {
        // Handle mobile file
        jobId = await _repository.startBulkUpload(
          file: file,
          columnMapping: columnMapping,
        );
      } else {
        throw Exception('Invalid file type');
      }

      _startPolling(jobId);
    } catch (e) {
      _setBulkUploadState(
        BulkUploadState(
          status: BulkUploadStatus.error,
          error: e.toString(),
        ),
      );
      rethrow;
    }
  }

  void _startPolling(String jobId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final status = await _repository.getBulkUploadStatus(jobId);

        if (status['status'] == 'completed') {
          timer.cancel();
          _setBulkUploadState(
            BulkUploadState(
              status: BulkUploadStatus.completed,
              successCount: status['successCount'] ?? 0,
              errorCount: status['errorCount'] ?? 0,
            ),
          );
          loadProducts();
        } else if (status['status'] == 'failed') {
          timer.cancel();
          final errors = await _repository.getBulkUploadErrors(jobId);
          _setBulkUploadState(
            BulkUploadState(
              status: BulkUploadStatus.error,
              error: errors.isNotEmpty ? errors.first : 'Upload failed',
            ),
          );
        } else {
          _setBulkUploadState(
            BulkUploadState(
              status: BulkUploadStatus.uploading,
              processedRows: status['processedRows'],
              totalRows: status['totalRows'],
            ),
          );
        }
      } catch (e) {
        timer.cancel();
        _setBulkUploadState(
          BulkUploadState(
            status: BulkUploadStatus.error,
            error: e.toString(),
          ),
        );
      }
    });
  }

  void _setBulkUploadState(BulkUploadState state) {
    _bulkUploadState = state;
    notifyListeners();
  }

  void resetBulkUploadState() {
    _pollTimer?.cancel();
    _setBulkUploadState(BulkUploadState());
  }

  void clearState() {
    _products = [];
    // _currentProduct = null;
    notifyListeners();
  }
}
