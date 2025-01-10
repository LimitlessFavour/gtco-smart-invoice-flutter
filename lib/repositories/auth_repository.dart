import 'package:flutter/foundation.dart';
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

      if (response.statusCode == 200) {
        LoggerService.success('Login request successful');
        final authResponse = AuthResponse.fromJson(response.data);
        _client.setAuthToken(AuthToken.fromJson(response.data));
        return authResponse;
      }

      final errorResponse = ErrorResponse.fromJson(response.data);
      LoggerService.error('Login request failed', error: errorResponse.message);
      throw AuthException(errorResponse.message);
    } catch (e, stackTrace) {
      if (e is AuthException) {
        rethrow;
      }

      final errorMessage = e.toString().contains('SocketException')
          ? 'Network connection error'
          : 'Authentication failed. Please try again.';

      LoggerService.error(
        'Login request error',
        error: errorMessage,
        stackTrace: stackTrace,
      );
      throw AuthException(errorMessage);
    }
  }

  Future<AuthResponse> signup(SignupDto signupDto) async {
    try {
      final response =
          await _client.post('/auth/signup', data: signupDto.toJson());

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data);
        _client.setAuthToken(AuthToken.fromJson(response.data));
        return authResponse;
      }

      throw Exception(response.data['message'] ?? 'Signup failed');
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<AuthResponse> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        supabase.Provider.google,
        redirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );

      if (!response) {
        throw Exception('Google sign in was cancelled or failed');
      }

      // After successful OAuth, get the tokens from your backend
      final tokens = await _getTokensFromBackend('google');
      _client.setAuthToken(AuthToken.fromJson(tokens));

      return AuthResponse.fromJson(tokens);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  Future<AuthResponse> signInWithApple() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        supabase.Provider.apple,
        redirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );

      if (!response) {
        throw Exception('Apple sign in was cancelled or failed');
      }

      // After successful OAuth, get the tokens from your backend
      final tokens = await _getTokensFromBackend('apple');
      _client.setAuthToken(AuthToken.fromJson(tokens));

      return AuthResponse.fromJson(tokens);
    } catch (e) {
      throw Exception('Apple sign in failed: $e');
    }
  }

  Future<Map<String, dynamic>> _getTokensFromBackend(String provider) async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) throw Exception('No session found');

      final response = await _client.post('/auth/$provider/callback', data: {
        'access_token': session.accessToken,
        'refresh_token': session.refreshToken,
      });

      if (response.statusCode == 200) {
        return response.data;
      }

      throw Exception('Failed to get tokens from backend');
    } catch (e) {
      throw Exception('Failed to get tokens: $e');
    }
  }

  Future<void> logout() async {
    try {
      await Future.wait([
        _client.post('/auth/logout'),
        _supabase.auth.signOut(),
      ]);
      _client.setAuthToken(null);
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _client.post('/auth/reset-password', data: {'email': email});
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<void> verifyEmail(String token) async {
    try {
      await _client.post('/auth/verify-email', data: {'token': token});
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }
}
