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
  view,
}

enum ProductScreen {
  list,
  create,
}

enum ClientScreen {
  list,
  create,
}

enum SettingsScreen {
  list,
  basicInformation,
  brandAppearance,
  manageUsers,
  productsUpdate,
}

class NavigationService extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.dashboard;
  InvoiceScreen _currentInvoiceScreen = InvoiceScreen.list;
  String? _currentInvoiceId;
  ProductScreen _currentProductScreen = ProductScreen.list;
  ClientScreen _currentClientScreen = ClientScreen.list;
  SettingsScreen _currentSettingsScreen = SettingsScreen.list;

  NavigationService() {
    if (html.window != null) {
      // Initialize state based on current URL
      _handleUrlChange();
    }
  }

  AppScreen get currentScreen => _currentScreen;
  InvoiceScreen get currentInvoiceScreen => _currentInvoiceScreen;
  String? get currentInvoiceId => _currentInvoiceId;
  ProductScreen get currentProductScreen => _currentProductScreen;
  ClientScreen get currentClientScreen => _currentClientScreen;
  SettingsScreen get currentSettingsScreen => _currentSettingsScreen;

  bool canGoBack() {
    switch (_currentScreen) {
      case AppScreen.invoice:
        return _currentInvoiceScreen == InvoiceScreen.create || 
               _currentInvoiceScreen == InvoiceScreen.view;
      case AppScreen.product:
        return _currentProductScreen == ProductScreen.create;
      case AppScreen.client:
        return _currentClientScreen == ClientScreen.create;
      case AppScreen.settings:
        return _currentSettingsScreen != SettingsScreen.list;
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
      _currentInvoiceId = null;
    } else if (path.startsWith('/invoice')) {
      _currentScreen = AppScreen.invoice;
      
      if (path == '/invoice/create') {
        _currentInvoiceScreen = InvoiceScreen.create;
        _currentInvoiceId = null;
      } else if (path == '/invoice') {
        _currentInvoiceScreen = InvoiceScreen.list;
        _currentInvoiceId = null;
      } else {
        // Handle /invoice/{id} pattern
        final invoiceId = path.split('/').last;
        _currentInvoiceScreen = InvoiceScreen.view;
        _currentInvoiceId = invoiceId;
      }
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
        if (_currentInvoiceScreen == InvoiceScreen.create || 
            _currentInvoiceScreen == InvoiceScreen.view) {
          _currentInvoiceScreen = InvoiceScreen.list;
          _currentInvoiceId = null;
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
      case AppScreen.settings:
        if (_currentSettingsScreen != SettingsScreen.list) {
          _currentSettingsScreen = SettingsScreen.list;
          _updateBrowserUrl('/settings');
          notifyListeners();
          return true;
        }
        return false;
      default:
        return false;
    }
  }

  void navigateToInvoiceScreen(InvoiceScreen screen, {String? invoiceId}) {
    _currentInvoiceScreen = screen;
    _currentScreen = AppScreen.invoice;
    _currentInvoiceId = invoiceId;
    
    String path = '/invoice';
    if (screen == InvoiceScreen.create) {
      path = '$path/create';
    } else if (screen == InvoiceScreen.view && invoiceId != null) {
      path = '$path/$invoiceId';
    }
    
    _updateBrowserUrl(path);
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

  void navigateToSettingsScreen(SettingsScreen screen) {
    _currentSettingsScreen = screen;
    _currentScreen = AppScreen.settings;
    _updateBrowserUrl('/settings${screen == SettingsScreen.list ? '' : '/${screen.toString().split('.').last}'}');
    notifyListeners();
  }

  void navigateTo(AppScreen screen) {
    _currentScreen = screen;
    _updateBrowserUrl('/${screen.toString().split('.').last.toLowerCase()}');
    notifyListeners();
  }
}
