import 'package:flutter/material.dart';
import '../repositories/onboarding_repository.dart';
import '../models/auth/user.dart';

class OnboardingProvider extends ChangeNotifier {
  final OnboardingRepository _repository;
  bool _isLoading = false;
  String? _error;

  OnboardingProvider(this._repository);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<User?> onboardUser({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String location,
    String? source,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = await _repository.onboardUser(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        location: location,
        source: source,
      );

      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> onboardCompany({
    required String companyName,
    required String description,
    String? logo,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _repository.onboardCompany(
        companyName: companyName,
        description: description,
        logo: logo,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
