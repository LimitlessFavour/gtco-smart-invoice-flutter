import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/auth/user.dart';
import '../models/auth/auth_dtos.dart';
import '../services/dio_client.dart';
import '../services/logger_service.dart';
import '../exceptions/auth_exception.dart';
import '../providers/auth_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class OnboardingRepository {
  final DioClient _client;
  final AuthProvider _authProvider;

  OnboardingRepository(this._client, this._authProvider);

  Future<User> onboardUser({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String location,
    String? source,
  }) async {
    try {
      // Get the current auth token
      final token = _authProvider.token;
      if (token == null) {
        LoggerService.error('No auth token available');
        throw AuthException('Authentication required');
      }

      LoggerService.debug('Making user onboarding request', {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'location': location,
        'source': source,
      });
      if (token == null) {
        LoggerService.error('No auth token available');
        throw AuthException('Authentication required');
      }

      final response = await _client.post(
        '/user/onboard/user',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'location': location,
          'source': source,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      if (response.statusCode == 201) {
        LoggerService.success('User onboarding successful', {
          'firstName': firstName,
          'lastName': lastName,
        });

        final user = User.fromJson(response.data);
        _authProvider.updateUser(user);
        return user;
      }

      final errorResponse = ErrorResponse.fromJson(response.data);
      LoggerService.error('User onboarding failed', error: {
        'status': response.statusCode,
        'message': errorResponse.message,
        'data': response.data,
      });
      throw AuthException(errorResponse.message);
    } catch (e, stackTrace) {
      LoggerService.error('User onboarding error',
          error: e, stackTrace: stackTrace);
      if (e is AuthException) rethrow;
      throw AuthException('User onboarding failed. Please try again.');
    }
  }

  Future<bool> onboardCompany({
    required String companyName,
    required String description,
    String? logo,
  }) async {
    try {
      final token = _authProvider.token;
      if (token == null) throw AuthException('No auth token available');

      LoggerService.debug('Making company onboarding request', {
        'companyName': companyName,
        'description': description,
        'hasLogo': logo != null,
      });

      final Map<String, dynamic> formMap = {
        'companyName': companyName,
        'description': description,
      };

      if (logo != null) {
        if (kIsWeb) {
          // For web, we need to handle the file differently
          final pickedFile = XFile(logo);
          final bytes = await pickedFile.readAsBytes();
          final filename = logo.split('/').last;
          formMap['logo'] = MultipartFile.fromBytes(
            bytes,
            filename: filename,
          );
        } else {
          // For mobile, we can use the file directly
          formMap['logo'] = await MultipartFile.fromFile(logo);
        }
      }

      final formData = FormData.fromMap(formMap);

      final response = await _client.post(
        '/user/onboard/company',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      if (response.statusCode == 201) {
        LoggerService.success('Company onboarding successful', {
          'companyName': companyName,
        });
        return true;
      }

      final errorResponse = ErrorResponse.fromJson(response.data);
      LoggerService.error('Company onboarding failed', error: {
        'status': response.statusCode,
        'message': errorResponse.message,
        'data': response.data,
      });
      throw AuthException(errorResponse.message);
    } catch (e, stackTrace) {
      LoggerService.error('Company onboarding error',
          error: e, stackTrace: stackTrace);
      if (e is AuthException) rethrow;
      throw AuthException('Company onboarding failed. Please try again.');
    }
  }
}
