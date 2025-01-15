import 'package:flutter/material.dart';
import '../models/client.dart';
import '../repositories/client_repository.dart';
import '../services/logger_service.dart';

class ClientProvider extends ChangeNotifier {
  final ClientRepository _repository;
  List<Client> _clients = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  ClientProvider(this._repository);

  List<Client> get clients {
    final filtered = _clients
        .where((client) =>
            client.fullName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            client.email.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    return filtered;
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasClients => _clients.isNotEmpty;

  Future<void> loadClients() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _clients = await _repository.getClients();
      LoggerService.debug('Loaded clients count: ${_clients.length}');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      LoggerService.error('Error loading clients', error: e);
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Client?> getClientById(String id) async {
    try {
      // First check if the client exists in our local list
      final localClient = _clients.where((c) => c.id == id).firstOrNull;

      if (localClient != null) {
        LoggerService.debug(
            'Client found in local cache: ${localClient.fullName}');
        return localClient;
      }

      LoggerService.debug('Client not found locally, fetching from API...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      final client = await _repository.getClientById(id);
      _isLoading = false;
      notifyListeners();
      return client;
    } catch (e) {
      LoggerService.error('Error getting client by ID', error: e);
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> createClient(Client client) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newClient = await _repository.createClient(client);
      _clients.insert(0, newClient);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      LoggerService.error('Error creating client', error: e);
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateClient(Client client) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedClient = await _repository.updateClient(client);
      final index = _clients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        _clients[index] = updatedClient;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      LoggerService.error('Error updating client', error: e);
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteClient(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _repository.deleteClient(id);
      if (success) {
        _clients.removeWhere((client) => client.id == id);
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      LoggerService.error('Error deleting client', error: e);
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void searchClients(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
