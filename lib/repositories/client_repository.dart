import '../models/client.dart';
import '../services/api_client.dart';

class ClientRepository {
  final ApiClient _apiClient;

  ClientRepository(this._apiClient);

  Future<List<Client>> getClients() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // When ready for real API:
      // final response = await _apiClient.get('/clients');
      // return (response['data'] as List).map((json) => Client.fromJson(json)).toList();

      // Return mock data
      return [
        Client(
          id: '1',
          companyId: '1',
          firstName: 'John',
          lastName: 'Snow',
          email: 'john@example.com',
          phoneNumber: '1234567890',
          address: '123 Street',
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load clients: $e');
    }
  }

  Future<bool> createClient(Client client) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // When ready for real API:
      // final response = await _apiClient.post('/clients', client.toJson());
      // return response['success'] ?? false;

      return true;
    } catch (e) {
      throw Exception('Failed to create client: $e');
    }
  }

  Future<bool> deleteClient(String id) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // When ready for real API:
      // final response = await _apiClient.delete('/clients/$id');
      // return response['success'] ?? false;

      return true;
    } catch (e) {
      throw Exception('Failed to delete client: $e');
    }
  }

  Future<bool> updateClient(Client client) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // When ready for real API:
      // final response = await _apiClient.put('/clients/${client.id}', client.toJson());
      // return response['success'] ?? false;

      return true;
    } catch (e) {
      throw Exception('Failed to update client: $e');
    }
  }
} 