import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../models/client.dart';
import '../services/dio_client.dart';
import '../services/logger_service.dart';

class ClientRepository {
  final DioClient _dioClient;
  // final CacheService _cacheService;

  ClientRepository(this._dioClient);

  Future<List<Client>> getClients() async {
    try {
      final response = await _dioClient.get('/client');
      if (response.data == null) {
        throw Exception('Invalid response format');
      }

      // Based on the API schema, the response will be wrapped in a ClientListResponseDto
      final clients = (response.data['data'] as List? ?? [])
          .map((json) => Client.fromJson(json))
          .toList();
      return clients;
    } catch (e) {
      LoggerService.error('Failed to load clients', error: e);
      throw Exception('Failed to load clients: $e');
    }
  }

  Future<Client> getClientById(String id) async {
    try {
      final response = await _dioClient.get('/client/$id');
      return Client.fromJson(response.data);
    } catch (e) {
      LoggerService.error('Failed to get client', error: e);
      throw Exception('Failed to get client: $e');
    }
  }

  Future<Client> createClient(Client client) async {
    try {
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 2));
      }

      final Map<String, dynamic> data = {
        'firstName': client.firstName,
        'lastName': client.lastName,
        'email': client.email,
        'phoneNumber': client.phoneNumber,
        'address': client.address,
      };

      final response = await _dioClient.post('/client', data: data);
      return Client.fromJson(response.data);
    } catch (e) {
      LoggerService.error('Failed to create client', error: e);
      throw Exception('Failed to create client: $e');
    }
  }

  Future<Client> updateClient(Client client) async {
    try {
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 2));
      }

      final Map<String, dynamic> data = {
        'firstName': client.firstName,
        'lastName': client.lastName,
        'email': client.email,
        'phoneNumber': client.phoneNumber,
        'address': client.address,
      };

      final response = await _dioClient.put('/client/${client.id}', data: data);
      return Client.fromJson(response.data);
    } catch (e) {
      LoggerService.error('Failed to update client', error: e);
      throw Exception('Failed to update client: $e');
    }
  }

  Future<bool> deleteClient(String id) async {
    try {
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 2));
      }

      await _dioClient.delete('/client/$id');
      return true;
    } catch (e) {
      LoggerService.error('Failed to delete client', error: e);
      throw Exception('Failed to delete client: $e');
    }
  }

  Future<Map<String, dynamic>> validateBulkUpload(File file) async {
    try {
      final form = FormData.fromMap({});

      if (kIsWeb) {
        // For web platform
        final pickedFile = XFile(file.path);
        final bytes = await pickedFile.readAsBytes();
        form.files.add(MapEntry(
          'file',
          MultipartFile.fromBytes(
            bytes,
            filename: 'clients.csv',
            contentType: MediaType('text', 'csv'),
          ),
        ));
      } else {
        // For mobile platform
        form.files.add(MapEntry(
          'file',
          await MultipartFile.fromFile(
            file.path,
            filename: 'clients.csv',
            contentType: MediaType('text', 'csv'),
          ),
        ));
      }

      final response = await _dioClient.post(
        '/client/bulk-upload/validate',
        data: form,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
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
      // Create reversed mapping to match API expectations
      final reversedMapping =
          columnMapping.map((key, value) => MapEntry(value, key));

      final form = FormData.fromMap({
        'columnMapping': jsonEncode(reversedMapping),
        'defaultValues': jsonEncode(defaultValues ?? {}),
        'batchSize': 100,
      });

      if (kIsWeb) {
        // For web platform
        final pickedFile = XFile(file.path);
        final bytes = await pickedFile.readAsBytes();
        form.files.add(MapEntry(
          'file',
          MultipartFile.fromBytes(
            bytes,
            filename: 'clients.csv',
            contentType: MediaType('text', 'csv'),
          ),
        ));
      } else {
        // For mobile platform
        form.files.add(MapEntry(
          'file',
          await MultipartFile.fromFile(
            file.path,
            filename: 'clients.csv',
            contentType: MediaType('text', 'csv'),
          ),
        ));
      }

      final response = await _dioClient.post(
        '/client/bulk-upload',
        data: form,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response.data['jobId'];
    } catch (e) {
      throw Exception('Failed to start bulk upload: $e');
    }
  }

  Future<Map<String, dynamic>> getBulkUploadStatus(String jobId) async {
    try {
      final response =
          await _dioClient.get('/client/bulk-upload/$jobId/status');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get job status: $e');
    }
  }

  Future<List<String>> getBulkUploadErrors(String jobId) async {
    try {
      final response =
          await _dioClient.get('/client/bulk-upload/$jobId/errors');
      return List<String>.from(response.data);
    } catch (e) {
      throw Exception('Failed to get upload errors: $e');
    }
  }

  Future<Map<String, dynamic>> validateBulkUploadWeb(
    Uint8List bytes,
    String filename,
  ) async {
    try {
      final form = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: MediaType('text', 'csv'),
        ),
      });

      final response = await _dioClient.post(
        '/client/bulk-upload/validate',
        data: form,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to validate file: $e');
    }
  }

  Future<String> startBulkUploadWeb({
    required Uint8List bytes,
    required String filename,
    required Map<String, String> columnMapping,
    Map<String, dynamic>? defaultValues,
  }) async {
    try {
      final form = FormData.fromMap({
        'columnMapping': jsonEncode(columnMapping),
        'defaultValues': jsonEncode(defaultValues ?? {}),
        'batchSize': 100,
        'file': MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: MediaType('text', 'csv'),
        ),
      });

      final response = await _dioClient.post(
        '/client/bulk-upload',
        data: form,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response.data['jobId'];
    } catch (e) {
      throw Exception('Failed to start bulk upload: $e');
    }
  }
}
