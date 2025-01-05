import 'package:flutter/material.dart';

enum AppScreen {
  dashboard,
  invoice,
  product,
  client,
  settings,
  helpCenter,
}

class NavigationService extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.dashboard;

  AppScreen get currentScreen => _currentScreen;

  void navigateTo(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }
} 