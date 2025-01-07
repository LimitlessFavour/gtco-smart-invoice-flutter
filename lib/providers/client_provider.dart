import 'package:flutter/material.dart';
import '../models/client.dart';
import '../repositories/client_repository.dart';

class ClientProvider extends ChangeNotifier {
  final ClientRepository _repository;
  bool _isLoading = false;
  String? _error;
  List<Client> _clients = [];

  ClientProvider(this._repository);

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Client> get clients => _clients;
  bool get hasClients => _clients.isNotEmpty;

  Future<void> loadClients() async {
    try {
      _isLoading = true;
      notifyListeners();

      _clients = await _repository.getClients();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createClient(Client client) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repository.createClient(client);

      if (result) {
        _clients.insert(0, client);
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

  Future<bool> deleteClient(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repository.deleteClient(id);

      if (result) {
        _clients.removeWhere((client) => client.id == id);
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

  Future<bool> updateClient(Client client) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _repository.updateClient(client);

      if (result) {
        final index = _clients.indexWhere((c) => c.id == client.id);
        if (index != -1) {
          _clients[index] = client;
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

  Client getClientById(String id) {
    final client = _clients.firstWhere(
      (client) => client.id == id,
      orElse: () => throw Exception('Client not found'),
    );
    return client;
  }
}
