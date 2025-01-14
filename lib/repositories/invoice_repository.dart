import '../models/invoice.dart';
import '../models/client.dart';
import '../services/api_client.dart';

class InvoiceRepository {
  final ApiClient _apiClient;

  InvoiceRepository(this._apiClient);

  Future<List<Invoice>> getInvoices() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // When ready for real API:
      // final response = await _apiClient.get('/invoices');
      // return (response['data'] as List).map((json) => Invoice.fromJson(json)).toList();

      // Return mock data
      return [
        Invoice(
          id: '1',
          companyId: '1',
          clientId: '1',
          invoiceNumber: 'INV-001',
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: 'unpaid',
          totalAmount: 1500.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          items: [],
          client: Client(
            id: '1',
            companyId: '1',
            firstName: 'John',
            lastName: 'Snow',
            email: 'john@example.com',
            phoneNumber: '1234567890',
            mobileNumber: '1234567890',
            address: '123 Street',
          ),
        ),
        Invoice(
          id: '2',
          companyId: '1',
          clientId: '1',
          invoiceNumber: '1001',
          dueDate: DateTime.now(),
          status: 'paid',
          totalAmount: 80000,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          items: [],
          client: Client(
            id: '1',
            companyId: '1',
            firstName: 'John',
            lastName: 'Snow',
            email: 'john@example.com',
            phoneNumber: '1234567890',
            mobileNumber: '1234567890',
            address: '123 Street',
          ),
        ),
        Invoice(
          id: '3',
          companyId: '1',
          clientId: '1',
          invoiceNumber: '12345',
          dueDate: DateTime.now(),
          status: 'drafted',
          totalAmount: 120000,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          items: [],
          client: Client(
            id: '1',
            companyId: '1',
            firstName: 'John',
            lastName: 'Snow',
            email: 'john@example.com',
            phoneNumber: '1234567890',
            mobileNumber: '1234567890',
            address: '123 Street',
          ),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load invoices: $e');
    }
  }

  Future<bool> sendInvoice(Invoice invoice) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // When ready for real API:
      // final response = await _apiClient.post('/invoices/send', invoice.toJson());
      // return response['success'] ?? false;

      return true;
    } catch (e) {
      throw Exception('Failed to send invoice: $e');
    }
  }
}
