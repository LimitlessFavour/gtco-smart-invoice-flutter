import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gtco_smart_invoice_flutter/services/logger_service.dart';

import '../models/create_product.dart';
import '../models/product.dart';
import '../services/dio_client.dart';

class ProductRepository {
  final DioClient _dioClient;

  ProductRepository(this._dioClient);

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dioClient.get('/product');
      if (response.data == null || response.data['products'] == null) {
        throw Exception('Invalid response format');
      }
      final products = (response.data['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return products;
    } catch (e) {
      LoggerService.error('Failed to load products', error: e);
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await _dioClient.get('/product/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  Future<Product> createProduct(CreateProduct product) async {
    try {
      //await for 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      Map<String, dynamic> formData = {
        'productName': product.productName,
        'description': product.description,
        //TODO: mod herre for errors.
        'category': product.category.name,
        'price': product.price,
        'defaultQuantity': product.defaultQuantity,
        'vatCategory': product.vatCategory.value,
      };

      if (product.sku != null) {
        formData['sku'] = product.sku;
      }

      if (product.image != null) {
        final form = FormData.fromMap({
          ...formData,
          'image': await MultipartFile.fromFile(product.image!),
        });
        final response = await _dioClient.post('/product', data: form);
        return Product.fromJson(response.data);
      }

      // If no image, send regular JSON
      final response = await _dioClient.post('/product', data: formData);
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<Product> updateProduct({
    required String id,
    required CreateProduct product,
  }) async {
    try {
      Map<String, dynamic> formData = {
        'productName': product.productName,
        'description': product.description,
        'category': product.category.name,
        'price': product.price,
        'defaultQuantity': product.defaultQuantity,
        'vatCategory': product.vatCategory.value,
      };

      if (product.sku != null) {
        formData['sku'] = product.sku;
      }

      if (product.image != null) {
        final form = FormData.fromMap({
          ...formData,
          'image': await MultipartFile.fromFile(product.image!),
        });
        final response = await _dioClient.put('/product/$id', data: form);
        return Product.fromJson(response.data);
      }

      // If no image, send regular JSON
      final response = await _dioClient.put('/product/$id', data: formData);
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<Product> deleteProduct(String id) async {
    try {
      //if debug, wait 2 seconds
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final response = await _dioClient.delete('/product/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<Map<String, dynamic>> validateBulkUpload(File file) async {
    try {
      final form = FormData.fromMap({
        'file':
            await MultipartFile.fromFile(file.path, filename: 'products.csv'),
      });

      final response =
          await _dioClient.post('/product/bulk-upload/validate', data: form);
      return response.data;
    } catch (e) {
      throw Exception('Failed to validate file: $e');
    }
  }

  Future<String> startBulkUpload({
    required File file,
    required Map<String, String> columnMapping,
    Map<String, dynamic>? defaultValues,
  }) async {
    try {
      final form = FormData.fromMap({
        'file':
            await MultipartFile.fromFile(file.path, filename: 'products.csv'),
        'columnMapping': jsonEncode(columnMapping),
        if (defaultValues != null) 'defaultValues': jsonEncode(defaultValues),
        'batchSize': 100,
      });

      final response =
          await _dioClient.post('/product/bulk-upload', data: form);
      return response.data['jobId'];
    } catch (e) {
      throw Exception('Failed to start bulk upload: $e');
    }
  }

  Future<Map<String, dynamic>> getBulkUploadStatus(String jobId) async {
    try {
      final response =
          await _dioClient.get('/product/bulk-upload/$jobId/status');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get job status: $e');
    }
  }

  Future<List<String>> getBulkUploadErrors(String jobId) async {
    try {
      final response =
          await _dioClient.get('/product/bulk-upload/$jobId/errors');
      return List<String>.from(response.data);
    } catch (e) {
      throw Exception('Failed to get job errors: $e');
    }
  }
}
