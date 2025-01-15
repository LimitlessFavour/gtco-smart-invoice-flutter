import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/logger_service.dart';
import '../models/client.dart';
import '../services/dio_client.dart';

class ClientRepository {
  final DioClient _dioClient;

  ClientRepository(this._dioClient);

  Future<List<Client>> getClients() async {
    try {
      final response = await _dioClient.get('/client');
      if (response.data == null) {
        throw Exception('Invalid response format');
      }

      // Based on the API schema, the response will be wrapped in a ClientListResponseDto
      final clients = (response.data['data'] as List)
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
}
