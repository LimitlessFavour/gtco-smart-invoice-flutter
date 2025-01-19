import 'package:flutter/foundation.dart';
import 'package:gtco_smart_invoice_flutter/models/auth/user.dart';
import 'package:gtco_smart_invoice_flutter/providers/client_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/dashboard_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/product_provider.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth/auth_token.dart';
import '../models/auth/auth_dtos.dart';
import '../repositories/auth_repository.dart';
import '../services/logger_service.dart';
import '../exceptions/auth_exception.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  AuthToken? _token;
  bool _isLoading = false;
  String? _error;
  User? _user;
  SharedPreferences? _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  AuthProvider(this._repository) {
    _initSharedPrefs();
  }

  Future<void> _initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadPersistedState();
  }

  Future<void> _loadPersistedState() async {
    if (_prefs == null) return;

    try {
      final tokenJson = _prefs!.getString(_tokenKey);
      final userJson = _prefs!.getString(_userKey);

      if (tokenJson != null) {
        final token = AuthToken.fromJson(json.decode(tokenJson));
        if (!token.isAccessTokenExpired && !token.isRefreshTokenExpired) {
          _token = token;

          if (userJson != null) {
            _user = User.fromJson(json.decode(userJson));
          }

          notifyListeners();
        } else {
          // Clear expired token
          await _clearPersistedState();
        }
      }
    } catch (e) {
      LoggerService.error('Error loading persisted state', error: e);
      await _clearPersistedState();
    }
  }

  Future<void> _persistState() async {
    if (_prefs == null) return;

    try {
      if (_token != null) {
        await _prefs!.setString(_tokenKey, json.encode(_token!.toJson()));
      } else {
        await _prefs!.remove(_tokenKey);
      }

      if (_user != null) {
        await _prefs!.setString(_userKey, json.encode(_user!.toJson()));
      } else {
        await _prefs!.remove(_userKey);
      }
    } catch (e) {
      LoggerService.error('Error persisting state', error: e);
    }
  }

  Future<void> _clearPersistedState() async {
    if (_prefs == null) return;

    try {
      // Clear auth state
      await _prefs!.remove(_tokenKey);
      await _prefs!.remove(_userKey);
      _token = null;
      _user = null;

      // Clear other providers' state using BuildContext
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null) {
        // Clear Invoice Provider state
        context.read<InvoiceProvider>().clearState();

        // Clear Product Provider state
        context.read<ProductProvider>().clearState();

        // Clear Client Provider state
        context.read<ClientProvider>().clearState();

        // Clear Dashboard Provider state
        context.read<DashboardProvider>().clearState();

        // Also clear navigation state
        context.read<NavigationService>().clearNavigationState();
      }

      notifyListeners();
    } catch (e) {
      LoggerService.error('Error clearing persisted state', error: e);
    }
  }

  bool get isAuthenticated => _token != null && !_token!.isAccessTokenExpired;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  bool get isOnboardingCompleted => _user?.onboardingCompleted ?? false;
  AuthToken? get token => _token;
  String? get accessToken => _token?.accessToken;

  void _startLoading() {
    _isLoading = true;
    _error = null;
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

  void _handleAuthResponse(AuthResponse response) async {
    _token = AuthToken.fromJson({
      'access_token': response.accessToken,
      'refresh_token': response.refreshToken,
    });
    _user = response.user;
    await _persistState();
    LoggerService.success('Authentication successful', {
      'user': response.user.email,
      'onboardingCompleted': response.user.onboardingCompleted,
      'tokenExpiry': _token?.accessTokenExpiry.toIso8601String(),
    });
  }

  void _handleSignupAuthResponse(SignupAuthResponse response) {
    _token = AuthToken.fromJson({
      'access_token': response.accessToken,
      'refresh_token': response.refreshToken,
    });
    LoggerService.success('Authentication successful', {
      'user': response.user.email,
      'onboardingCompleted': false,
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
      _handleSignupAuthResponse(response);
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

      if (_token?.refreshToken != null) {
        await _repository.logout(_token!.refreshToken);
      }

      await _clearPersistedState();
      LoggerService.success('User logged out successfully');
      _stopLoading(null);
    } catch (e) {
      LoggerService.error('Logout failed', error: e);
      _stopLoading('Failed to logout');
      rethrow;
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

  void updateUser(User user) async {
    _user = user;
    await _persistState();
    LoggerService.success('User updated', {
      'email': user.email,
      'onboardingCompleted': user.onboardingCompleted,
    });
    notifyListeners();
  }

  void handleTokenRefresh(AuthToken? newToken) async {
    _token = newToken;
    if (newToken == null) {
      await logout();
    } else {
      await _persistState();
    }
    notifyListeners();
  }
}
