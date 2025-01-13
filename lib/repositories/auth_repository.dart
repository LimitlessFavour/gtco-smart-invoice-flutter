import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:gtco_smart_invoice_flutter/exceptions/auth_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../services/dio_client.dart';
import '../models/auth/auth_token.dart';
import '../models/auth/auth_dtos.dart';
import '../services/logger_service.dart';

class AuthRepository {
  final DioClient _client;
  final supabase.SupabaseClient _supabase;

  AuthRepository(this._client) : _supabase = supabase.Supabase.instance.client;

  Future<AuthResponse> login(LoginDto loginDto) async {
    try {
      LoggerService.debug('Making login request', {'email': loginDto.email});
      final response =
          await _client.post('/auth/login', data: loginDto.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.debug('Login response data', {'data': response.data});

        final authResponse = AuthResponse.fromJson(response.data);
        _client.setAuthToken(AuthToken.fromJson({
          'access_token': authResponse.accessToken,
          'refresh_token': authResponse.refreshToken,
        }));

        LoggerService.success('Login request successful', {
          'userId': authResponse.user.id,
          'email': authResponse.user.email,
        });

        return authResponse;
      }

      final errorResponse = ErrorResponse.fromJson(response.data);
      LoggerService.error('Login request failed', error: {
        'status': response.statusCode,
        'message': errorResponse.message,
        'data': response.data,
      });
      throw AuthException(errorResponse.message);
    } catch (e, stackTrace) {
      if (e is AuthException) rethrow;

      LoggerService.error('Login request error',
          error: e, stackTrace: stackTrace);

      if (e.toString().contains('type \'Null\'')) {
        throw AuthException('Server response format error. Please try again.');
      }

      final message = e.toString().contains('SocketException')
          ? 'Network connection error'
          : 'Authentication failed. Please try again.';

      throw AuthException(message);
    }
  }

  Future<AuthResponse> signup(SignupDto signupDto) async {
    try {
      LoggerService.debug('Making signup request', {'email': signupDto.email});
      final response =
          await _client.post('/auth/signup', data: signupDto.toJson());

      if (response.statusCode == 201) {
        LoggerService.debug('Signup response data', {'data': response.data});

        final authResponse = AuthResponse.fromJson(response.data);
        _client.setAuthToken(AuthToken.fromJson({
          'access_token': authResponse.accessToken,
          'refresh_token': authResponse.refreshToken,
        }));

        LoggerService.success('Signup successful', {
          'userId': authResponse.user.id,
          'email': authResponse.user.email,
        });

        return authResponse;
      }

      final errorResponse = ErrorResponse.fromJson(response.data);
      LoggerService.error('Signup failed', error: {
        'status': response.statusCode,
        'message': errorResponse.message,
        'data': response.data,
      });
      throw AuthException(errorResponse.message);
    } catch (e, stackTrace) {
      LoggerService.error('Signup error', error: e, stackTrace: stackTrace);
      throw AuthException('Registration failed. Please try again.');
    }
  }

  Future<AuthResponse> signInWithGoogle() async {
    try {
      LoggerService.debug('Starting Google OAuth flow');

      String? redirectUrl;
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          redirectUrl = 'com.gtco.smart-invoice:/oauth2redirect';
        } else if (Platform.isIOS) {
          redirectUrl = 'com.gtco.smartinvoice://oauth2redirect';
        }
      }

      final response = await _supabase.auth.signInWithOAuth(
        supabase.Provider.google,
        redirectTo: redirectUrl,
        scopes: 'email profile',
      );

      if (!response) {
        throw AuthException('Google sign in was cancelled');
      }

      final tokens = await _getTokensFromBackend('google');
      return _handleOAuthResponse(tokens);
    } catch (e, stackTrace) {
      LoggerService.error('Google sign in error',
          error: e, stackTrace: stackTrace);

      if (e is PlatformException) {
        throw AuthException('Google sign in failed: ${e.message}');
      }

      throw AuthException('Google sign in failed. Please try again.');
    }
  }

  Future<AuthResponse> signInWithApple() async {
    try {
      LoggerService.debug('Starting Apple OAuth flow');

      // Only proceed with Apple Sign In on iOS or web
      if (!kIsWeb && !Platform.isIOS) {
        throw AuthException(
            'Apple Sign In is only available on iOS devices and web');
      }

      String? redirectUrl;
      if (!kIsWeb && Platform.isIOS) {
        redirectUrl = 'com.gtco.smartinvoice://oauth2redirect';
      }

      final response = await _supabase.auth.signInWithOAuth(
        supabase.Provider.apple,
        redirectTo: redirectUrl,
        scopes: 'email name',
      );

      if (!response) {
        throw AuthException('Apple sign in was cancelled');
      }

      final tokens = await _getTokensFromBackend('apple');
      return _handleOAuthResponse(tokens);
    } catch (e, stackTrace) {
      LoggerService.error('Apple sign in error',
          error: e, stackTrace: stackTrace);

      if (e is PlatformException) {
        throw AuthException('Apple sign in failed: ${e.message}');
      }

      throw AuthException('Apple sign in failed. Please try again.');
    }
  }

  Future<Map<String, dynamic>> _getTokensFromBackend(String provider) async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) throw AuthException('No session found');

      final response = await _client.post('/auth/$provider/callback', data: {
        'access_token': session.accessToken,
        'refresh_token': session.refreshToken,
      });

      if (response.statusCode == 200) {
        return response.data;
      }

      final errorResponse = ErrorResponse.fromJson(response.data);
      throw AuthException(errorResponse.message);
    } catch (e, stackTrace) {
      LoggerService.error('Token exchange error',
          error: e, stackTrace: stackTrace);
      throw AuthException(
          'Failed to complete authentication. Please try again.');
    }
  }

  AuthResponse _handleOAuthResponse(Map<String, dynamic> tokens) {
    final authResponse = AuthResponse.fromJson(tokens);
    _client.setAuthToken(AuthToken.fromJson({
      'access_token': authResponse.accessToken,
      'refresh_token': authResponse.refreshToken,
    }));
    return authResponse;
  }

  Future<void> logout() async {
    try {
      LoggerService.debug('Logging out user');
      await Future.wait([
        _client.post('/auth/logout'),
        _supabase.auth.signOut(),
      ]);
      _client.setAuthToken(null);
      LoggerService.success('Logout successful');
    } catch (e, stackTrace) {
      LoggerService.error('Logout error', error: e, stackTrace: stackTrace);
      throw AuthException('Logout failed. Please try again.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      LoggerService.debug('Requesting password reset', {'email': email});
      await _client.post('/auth/reset-password', data: {'email': email});
      LoggerService.success('Password reset email sent');
    } catch (e, stackTrace) {
      LoggerService.error('Password reset error',
          error: e, stackTrace: stackTrace);
      throw AuthException('Password reset failed. Please try again.');
    }
  }

  Future<void> verifyEmail(String token) async {
    try {
      LoggerService.debug('Verifying email');
      await _client.post('/auth/verify-email', data: {'token': token});
      LoggerService.success('Email verification successful');
    } catch (e, stackTrace) {
      LoggerService.error('Email verification error',
          error: e, stackTrace: stackTrace);
      throw AuthException('Email verification failed. Please try again.');
    }
  }
}
