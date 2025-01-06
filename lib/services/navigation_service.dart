import 'dart:html' if (dart.library.html) 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

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

  NavigationService() {
    if (html.window != null) {
      // Initialize state based on current URL
      _handleUrlChange();
    }
  }

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

  void initializeHistory() {
    html.window.onPopState.listen((event) {
      _handleUrlChange();
    });
  }

  void _handleUrlChange() {
    final path = html.window.location.pathname ?? '/';
    
    if (path == '/') {
      _currentScreen = AppScreen.dashboard;
    } else if (path.startsWith('/invoice')) {
      _currentScreen = AppScreen.invoice;
      _currentInvoiceScreen = path == '/invoice/create' 
          ? InvoiceScreen.create 
          : InvoiceScreen.list;
    } else if (path.startsWith('/product')) {
      _currentScreen = AppScreen.product;
      _currentProductScreen = path == '/product/create' 
          ? ProductScreen.create 
          : ProductScreen.list;
    } else if (path.startsWith('/client')) {
      _currentScreen = AppScreen.client;
      _currentClientScreen = path == '/client/create' 
          ? ClientScreen.create 
          : ClientScreen.list;
    }
    
    notifyListeners();
  }

  void _updateBrowserUrl(String path) {
    html.window.history.pushState(null, '', path);
    _handleUrlChange(); // Add this line to ensure state is updated
  }

  bool handleBackPress() {
    if (!canGoBack()) return false;

    switch (_currentScreen) {
      case AppScreen.invoice:
        if (_currentInvoiceScreen == InvoiceScreen.create) {
          _currentInvoiceScreen = InvoiceScreen.list;
          _updateBrowserUrl('/invoice');
          notifyListeners();
          return true;
        }
        return false;
      case AppScreen.product:
        if (_currentProductScreen == ProductScreen.create) {
          _currentProductScreen = ProductScreen.list;
          _updateBrowserUrl('/product');
          notifyListeners();
          return true;
        }
        return false;
      case AppScreen.client:
        if (_currentClientScreen == ClientScreen.create) {
          _currentClientScreen = ClientScreen.list;
          _updateBrowserUrl('/client');
          notifyListeners();
          return true;
        }
        return false;
      default:
        return false;
    }
  }

  void navigateToInvoiceScreen(InvoiceScreen screen) {
    _currentInvoiceScreen = screen;
    _currentScreen = AppScreen.invoice;
    _updateBrowserUrl('/invoice${screen == InvoiceScreen.create ? '/create' : ''}');
    notifyListeners();
  }

  void navigateToProductScreen(ProductScreen screen) {
    _currentProductScreen = screen;
    _currentScreen = AppScreen.product;
    _updateBrowserUrl('/product${screen == ProductScreen.create ? '/create' : ''}');
    notifyListeners();
  }

  void navigateToClientScreen(ClientScreen screen) {
    _currentClientScreen = screen;
    _currentScreen = AppScreen.client;
    _updateBrowserUrl('/client${screen == ClientScreen.create ? '/create' : ''}');
    notifyListeners();
  }

  void navigateTo(AppScreen screen) {
    _currentScreen = screen;
    _updateBrowserUrl('/${screen.toString().split('.').last.toLowerCase()}');
    notifyListeners();
  }
}
