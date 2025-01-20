import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/models/bulk_upload_state.dart';
import '../models/client.dart';
import '../repositories/client_repository.dart';
import '../services/logger_service.dart';
import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class ClientProvider extends ChangeNotifier {
  final ClientRepository _repository;
  List<Client> _clients = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  BulkUploadState _bulkUploadState = BulkUploadState();
  Timer? _statusCheckTimer;
  Client? _currentClient;
  bool _isLoadingDetails = false;
  Timer? _pollTimer;

  ClientProvider(this._repository) {
    loadClients();
  }

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
  BulkUploadState get bulkUploadState => _bulkUploadState;
  Client? get currentClient => _currentClient;
  bool get isLoadingDetails => _isLoadingDetails;

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

  Future<void> loadClientsIfEmpty() async {
    if (_clients.isEmpty) {
      await loadClients();
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
      if (newClient != null) {
        _clients.insert(0, newClient);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      _error = 'Failed to create client';
      notifyListeners();
      return false;
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
    _searchQuery = query.trim();
    if (_searchQuery.isEmpty) {
      // loadClients(); // Reload all clients when search is cleared
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> submitClient(Client client, bool isEdit) async {
    try {
      // Validate required fields
      if (client.firstName.trim().isEmpty ||
          client.lastName.trim().isEmpty ||
          client.email.trim().isEmpty ||
          client.phoneNumber.trim().isEmpty ||
          client.address.trim().isEmpty) {
        _error = 'All fields are required';
        notifyListeners();
        return false;
      }

      // Validate email format
      if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
          .hasMatch(client.email)) {
        _error = 'Please enter a valid email address';
        notifyListeners();
        return false;
      }

      // Validate phone number format
      if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(client.phoneNumber)) {
        _error = 'Please enter a valid phone number';
        notifyListeners();
        return false;
      }

      _isLoading = true;
      notifyListeners();

      final success =
          isEdit ? await updateClient(client) : await createClient(client);

      if (success) {
        // Refresh the clients list after successful operation
        await loadClients();
      }

      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    // _selectedClient = null;
    notifyListeners();
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

      // Extract headers from sampleData if they're not provided directly
      List<String> headers = [];
      if (response['headers'] != null) {
        headers = List<String>.from(response['headers']);
      } else if (response['sampleData'] != null &&
          response['sampleData'].isNotEmpty) {
        headers = List<String>.from(response['sampleData'][0].keys);
      }

      _setBulkUploadState(
        BulkUploadState(
          status: BulkUploadStatus.validated,
          headers: headers,
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
          loadClients();
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
    _clients = [];
    _currentClient = null;
    notifyListeners();
  }
}
