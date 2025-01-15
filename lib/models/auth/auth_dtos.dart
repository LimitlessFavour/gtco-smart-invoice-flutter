import 'package:gtco_smart_invoice_flutter/services/logger_service.dart';
import 'package:gtco_smart_invoice_flutter/models/auth/user.dart';

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
  final String firstName;
  final String lastName;
  final String companyName;

  SignupDto({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.companyName,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'companyName': companyName,
      };
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    LoggerService.debug('Parsing AuthResponse', {'json': json});

    try {
      return AuthResponse(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        user: User.fromJson(json['user'] as Map<String, dynamic>),
      );
    } catch (e) {
      LoggerService.error(
        'Error parsing AuthResponse',
        error: {'error': e.toString(), 'json': json},
      );
      rethrow;
    }
  }
}

class SignupAuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final SignupUser user; // Use SignupUser instead of User

  SignupAuthResponse({
    this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory SignupAuthResponse.fromJson(Map<String, dynamic> json) {
    LoggerService.debug('Parsing AuthResponse', {'json': json});

    try {
      return SignupAuthResponse(
        accessToken: json['access_token'] as String?,
        refreshToken: json['refresh_token'] as String?,
        user: SignupUser.fromJson(json['user'] as Map<String, dynamic>),
      );
    } catch (e) {
      LoggerService.error(
        'Error parsing AuthResponse',
        error: {'error': e.toString(), 'json': json},
      );
      rethrow;
    }
  }
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
}

class SignupUser {
  final String id;
  final String email;

  SignupUser({
    required this.id,
    required this.email,
  });

  factory SignupUser.fromJson(Map<String, dynamic> json) {
    return SignupUser(
      id: json['id'] as String,
      email: json['email'] as String,
    );
  }
}
