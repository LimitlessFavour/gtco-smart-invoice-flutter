import 'package:flutter/material.dart';

enum AppScreen {
  dashboard,
  invoice,
  product,
  client,
  settings,
  helpCenter,
}

enum InvoiceScreen {
  list,
  create,
}

enum ProductScreen {
  list,
  create,
}

enum ClientScreen {
  list,
  create,
}

class NavigationService extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.dashboard;
  InvoiceScreen _currentInvoiceScreen = InvoiceScreen.list;
  ProductScreen _currentProductScreen = ProductScreen.list;
  ClientScreen _currentClientScreen = ClientScreen.list;

  AppScreen get currentScreen => _currentScreen;
  InvoiceScreen get currentInvoiceScreen => _currentInvoiceScreen;
  ProductScreen get currentProductScreen => _currentProductScreen;
  ClientScreen get currentClientScreen => _currentClientScreen;

  bool canGoBack() {
    switch (_currentScreen) {
      case AppScreen.invoice:
        return _currentInvoiceScreen == InvoiceScreen.create;
      case AppScreen.product:
        return _currentProductScreen == ProductScreen.create;
      case AppScreen.client:
        return _currentClientScreen == ClientScreen.create;
      default:
        return false;
    }
  }

  bool handleBackPress() {
    if (!canGoBack()) return false;

    switch (_currentScreen) {
      case AppScreen.invoice:
        _currentInvoiceScreen = InvoiceScreen.list;
        notifyListeners();
        return true;
      case AppScreen.product:
        _currentProductScreen = ProductScreen.list;
        notifyListeners();
        return true;
      case AppScreen.client:
        _currentClientScreen = ClientScreen.list;
        notifyListeners();
        return true;
      default:
        return false;
    }
  }

  void navigateTo(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void navigateToInvoiceScreen(InvoiceScreen screen) {
    _currentInvoiceScreen = screen;
    _currentScreen = AppScreen.invoice;
    notifyListeners();
  }

  void navigateToProductScreen(ProductScreen screen) {
    _currentProductScreen = screen;
    _currentScreen = AppScreen.product;
    notifyListeners();
  }

  void navigateToClientScreen(ClientScreen screen) {
    _currentClientScreen = screen;
    _currentScreen = AppScreen.client;
    notifyListeners();
  }
}
