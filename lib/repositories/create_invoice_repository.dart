import 'package:dio/dio.dart';
import '../models/dtos/create_invoice_dto.dart';
import '../models/invoice.dart';
import '../services/dio_client.dart';
import '../services/logger_service.dart';

class CreateInvoiceRepository {
  final DioClient _dioClient;

  CreateInvoiceRepository(this._dioClient);

  Future<Invoice> createInvoice(CreateInvoiceDto dto) async {
    try {
      final response = await _dioClient.post(
        '/invoice',
        data: dto.toJson(),
      );

      LoggerService.debug('Create invoice response: $response');
      return Invoice.fromJson(response.data);
    } on DioException catch (e) {
      LoggerService.error('Error creating invoice', error: e);
      throw _handleDioError(e);
    } catch (e) {
      LoggerService.error('Unexpected error creating invoice', error: e);
      throw Exception('Failed to create invoice: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return Exception('Invalid invoice data');
      case 401:
        return Exception('Unauthorized. Please log in again');
      case 404:
        return Exception('Client or product not found');
      default:
        return Exception('Failed to create invoice: ${e.message}');
    }
  }
}
