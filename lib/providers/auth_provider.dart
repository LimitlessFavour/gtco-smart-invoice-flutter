import 'package:flutter/foundation.dart';
import '../models/auth/auth_token.dart';
import '../models/auth/auth_dtos.dart';
import '../repositories/auth_repository.dart';
import '../services/logger_service.dart';
import '../exceptions/auth_exception.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  AuthToken? _token;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _user;

  AuthProvider(this._repository);

  bool get isAuthenticated =>
      _token != null && !_token!.accessTokenExpiry.isBefore(DateTime.now());
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get user => _user;

  void _startLoading() {
    _isLoading = true;
    _error = null;
    LoggerService.info('Starting authentication process');
    notifyListeners();
  }

  void _stopLoading(String? error) {
    _isLoading = false;
    _error = error;
    if (error != null) {
      LoggerService.error('Authentication error', error: error);
    }
    notifyListeners();
  }

  void _handleAuthResponse(AuthResponse response) {
    _token = AuthToken.fromJson({
      'access_token': response.accessToken,
      'refresh_token': response.refreshToken,
    });
    _user = response.user;
    LoggerService.success('Authentication successful', {
      'user': response.user['email'],
      'tokenExpiry': _token?.accessTokenExpiry,
    });
  }

  Future<void> login(String email, String password) async {
    try {
      LoggerService.auth('Attempting login', {'email': email});
      _startLoading();

      final response = await _repository.login(
        LoginDto(email: email, password: password),
      );
      _handleAuthResponse(response);
      _stopLoading(null);
    } on AuthException catch (e) {
      _stopLoading(e.toString());
    } catch (e, stackTrace) {
      LoggerService.error('Unexpected login error',
          error: e, stackTrace: stackTrace);
      _stopLoading('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      _startLoading();
      final response = await _repository.signup(
        SignupDto(email: email, password: password),
      );
      _handleAuthResponse(response);
      _stopLoading(null);
    } catch (e) {
      _stopLoading(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _startLoading();
      final response = await _repository.signInWithGoogle();
      _handleAuthResponse(response);
      _stopLoading(null);
    } catch (e) {
      _stopLoading(e.toString());
    }
  }

  Future<void> signInWithApple() async {
    try {
      _startLoading();
      final response = await _repository.signInWithApple();
      _handleAuthResponse(response);
      _stopLoading(null);
    } catch (e) {
      _stopLoading(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      _startLoading();
      await _repository.logout();
      _token = null;
      _user = null;
      _stopLoading(null);
    } catch (e) {
      _stopLoading(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _startLoading();
      await _repository.resetPassword(email);
      _stopLoading(null);
    } catch (e) {
      _stopLoading(e.toString());
    }
  }

  Future<void> verifyEmail(String token) async {
    try {
      _startLoading();
      await _repository.verifyEmail(token);
      _stopLoading(null);
    } catch (e) {
      _stopLoading(e.toString());
    }
  }
}
