import 'package:dio/dio.dart';
import '../models/invoice.dart';
import '../models/dtos/create_invoice_dto.dart';
import '../services/dio_client.dart';
import '../services/logger_service.dart';
import '../models/paginated_invoice_response.dart';

class InvoiceRepository {
  final DioClient _dioClient;

  InvoiceRepository(this._dioClient);

  Future<PaginatedInvoiceResponse> getInvoices() async {
    try {
      final response = await _dioClient.get('/invoice');
      print('response: ${response.data}');
      return PaginatedInvoiceResponse.fromJson(response.data);
    } on DioException catch (e) {
      LoggerService.error('Error getting invoices', error: e);
      throw _handleDioError(e);
    }
  }

  Future<Invoice> createInvoice(CreateInvoiceDto dto) async {
    try {
      final response = await _dioClient.post(
        '/invoice',
        data: dto.toJson(),
      );
      return Invoice.fromJson(response.data);
    } on DioException catch (e) {
      LoggerService.error('Error creating invoice', error: e);
      throw _handleDioError(e);
    }
  }

  Future<Invoice> createDraftInvoice(CreateInvoiceDto dto) async {
    try {
      final response = await _dioClient.post(
        '/invoice/draft',
        data: dto.toJson(),
      );
      return Invoice.fromJson(response.data);
    } on DioException catch (e) {
      LoggerService.error('Error creating draft invoice', error: e);
      throw _handleDioError(e);
    }
  }

  Future<Invoice> markAsPaid(Invoice invoice) async {
    try {
      final response = await _dioClient.post(
        '/invoice/${invoice.id}/mark-paid',
      );

      return Invoice.fromJson(response.data);
    } on DioException catch (e) {
      LoggerService.error('Error marking invoice as paid', error: e);

      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return Exception('Invalid invoice data');
      case 401:
        return Exception('Unauthorized. Please log in again');
      case 404:
        return Exception('Resource not found');
      default:
        return Exception('An error occurred: ${e.message}');
    }
  }
}
