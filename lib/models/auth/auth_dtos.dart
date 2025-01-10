import 'package:gtco_smart_invoice_flutter/services/logger_service.dart';

class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class SignupDto {
  final String email;
  final String password;

  SignupDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    LoggerService.debug('Parsing AuthResponse', {'json': json});

    try {
      return AuthResponse(
        accessToken: json['accessToken'] ?? json['access_token'] as String,
        refreshToken: json['refreshToken'] ?? json['refresh_token'] as String,
        user: json['user'] as Map<String, dynamic>,
      );
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error parsing AuthResponse',
        error: {
          'error': e.toString(),
          'json': json,
        },
      );
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user': user,
      };
}

class ErrorResponse {
  final String message;
  final int statusCode;
  final String? error;
  final List<String>? errors;

  ErrorResponse({
    required this.message,
    required this.statusCode,
    this.error,
    this.errors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] as String? ?? 'Unknown error',
      statusCode: json['statusCode'] as int? ?? 500,
      error: json['error'] as String?,
      errors: (json['errors'] as List?)?.cast<String>(),
    );
  }

  @override
  String toString() {
    if (errors?.isNotEmpty ?? false) {
      return '${errors!.join(', ')} (Status: $statusCode)';
    }
    return '$message (Status: $statusCode)';
  }
}
