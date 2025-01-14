import 'package:flutter/foundation.dart';
import 'package:gtco_smart_invoice_flutter/models/auth/user.dart';
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
  User? _user;

  AuthProvider(this._repository);

  bool get isAuthenticated => _token != null && !_token!.isAccessTokenExpired;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  bool get isOnboardingCompleted => _user?.onboardingCompleted ?? false;
  AuthToken? get token => _token;

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
      'user': response.user.email,
      'onboardingCompleted': response.user.onboardingCompleted,
      'tokenExpiry': _token?.accessTokenExpiry.toIso8601String(),
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
      LoggerService.error(
        'Unexpected login error',
        error: e,
        stackTrace: stackTrace,
      );
      _stopLoading('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String companyName,
  }) async {
    try {
      _startLoading();
      final response = await _repository.signup(
        SignupDto(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          companyName: companyName,
        ),
      );
      _handleAuthResponse(response);
      _stopLoading(null);
    } on AuthException catch (e) {
      _stopLoading(e.toString());
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected signup error',
        error: e,
        stackTrace: stackTrace,
      );
      _stopLoading('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _startLoading();
      final response = await _repository.signInWithGoogle();
      _handleAuthResponse(response);
      _stopLoading(null);
    } on AuthException catch (e) {
      _stopLoading(e.toString());
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected Google sign-in error',
        error: e,
        stackTrace: stackTrace,
      );
      _stopLoading('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signInWithApple() async {
    try {
      _startLoading();
      final response = await _repository.signInWithApple();
      _handleAuthResponse(response);
      _stopLoading(null);
    } on AuthException catch (e) {
      _stopLoading(e.toString());
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected Apple sign-in error',
        error: e,
        stackTrace: stackTrace,
      );
      _stopLoading('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> logout() async {
    try {
      _startLoading();
      await _repository.logout();
      _token = null;
      _user = null;
      _stopLoading(null);
    } on AuthException catch (e) {
      _stopLoading(e.toString());
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected logout error',
        error: e,
        stackTrace: stackTrace,
      );
      _stopLoading('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _startLoading();
      await _repository.resetPassword(email);
      _stopLoading(null);
    } on AuthException catch (e) {
      _stopLoading(e.toString());
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected password reset error',
        error: e,
        stackTrace: stackTrace,
      );
      _stopLoading('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> verifyEmail(String token) async {
    try {
      _startLoading();
      await _repository.verifyEmail(token);
      _stopLoading(null);
    } on AuthException catch (e) {
      _stopLoading(e.toString());
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected email verification error',
        error: e,
        stackTrace: stackTrace,
      );
      _stopLoading('An unexpected error occurred. Please try again.');
    }
  }

  void updateUser(User user) {
    _user = user;
    LoggerService.success('User updated', {
      'email': user.email,
      'onboardingCompleted': user.onboardingCompleted,
    });
    notifyListeners();
  }

  void handleTokenRefresh(AuthToken? newToken) {
    _token = newToken;
    if (newToken == null) {
      // Token refresh failed, log out user
      logout();
    }
    notifyListeners();
  }
}
