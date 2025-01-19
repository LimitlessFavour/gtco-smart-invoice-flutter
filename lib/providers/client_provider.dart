import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/models/bulk_upload_state.dart';
import '../models/client.dart';
import '../repositories/client_repository.dart';
import '../services/logger_service.dart';
import 'dart:io';
import 'dart:async';

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

  Future<bool> submitClient(Client client, bool isEdit) async {
    try {
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

  Future<void> validateBulkUpload(File file) async {
    try {
      final response = await _repository.validateBulkUpload(file);

      // Extract headers from the first sample data item
      final headers = response['sampleData']?[0]?.keys.toList() ?? [];

      _bulkUploadState = BulkUploadState(
        status: BulkUploadStatus.validated,
        headers: headers,
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
      rethrow;
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

      _startStatusPolling();
    } catch (e) {
      _bulkUploadState = BulkUploadState(
        status: BulkUploadStatus.error,
        error: e.toString(),
      );
      notifyListeners();
      rethrow;
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
            await loadClients(); // Refresh client list
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

  void clearState() {
    _clients = [];
    _currentClient = null;
    notifyListeners();
  }
}
