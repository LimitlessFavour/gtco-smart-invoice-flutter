import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/main.dart';
import 'package:gtco_smart_invoice_flutter/providers/dashboard_provider.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_platform.dart';
import 'package:provider/provider.dart';

// Conditional import for web functionality
import 'web_navigation.dart' if (dart.library.io) 'mobile_navigation.dart';

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
  edit,
  bulkUpload,
}

enum ClientScreen {
  list,
  create,
  view,
  edit,
  bulkUpload,
}

enum SettingsScreen {
  list,
  basicInformation,
  brandAppearance,
  manageUsers,
  productsUpdate,
}

class NavigationService extends ChangeNotifier {
  final NavigationPlatform _platform;
  AppScreen _currentScreen = AppScreen.dashboard;
  InvoiceScreen _currentInvoiceScreen = InvoiceScreen.list;
  String? _currentInvoiceId;
  ProductScreen _currentProductScreen = ProductScreen.list;
  ClientScreen _currentClientScreen = ClientScreen.list;
  SettingsScreen _currentSettingsScreen = SettingsScreen.list;
  String? _currentClientId;
  String? _currentProductId;

  NavigationService() : _platform = createNavigationPlatform() {
    if (kIsWeb) {
      _platform.initializeHistory(handleUrlChange: _handleUrlChange);
    }
  }

  AppScreen get currentScreen => _currentScreen;
  InvoiceScreen get currentInvoiceScreen => _currentInvoiceScreen;
  String? get currentInvoiceId => _currentInvoiceId;
  ProductScreen get currentProductScreen => _currentProductScreen;
  ClientScreen get currentClientScreen => _currentClientScreen;
  SettingsScreen get currentSettingsScreen => _currentSettingsScreen;

  String? get currentClientId => _currentClientId;
  String? get currentProductId => _currentProductId;

  bool canGoBack() {
    switch (_currentScreen) {
      case AppScreen.invoice:
        return _currentInvoiceScreen == InvoiceScreen.create ||
            _currentInvoiceScreen == InvoiceScreen.view;
      case AppScreen.product:
        return _currentProductScreen == ProductScreen.create ||
            _currentProductScreen == ProductScreen.edit ||
            _currentProductScreen == ProductScreen.bulkUpload;
      case AppScreen.client:
        return _currentClientScreen == ClientScreen.create ||
            _currentClientScreen == ClientScreen.view ||
            _currentClientScreen == ClientScreen.edit ||
            _currentClientScreen == ClientScreen.bulkUpload;
      case AppScreen.settings:
        return _currentSettingsScreen != SettingsScreen.list;
      default:
        return false;
    }
  }

  void initializeHistory() {
    if (kIsWeb) {
      _platform.initializeHistory(handleUrlChange: _handleUrlChange);
    }
  }

  void _handleUrlChange() {
    if (!kIsWeb) return;

    final path = _platform.getCurrentPath();
    _updateNavigationState(path);
  }

  void _updateBrowserUrl(String path) {
    if (kIsWeb) {
      _platform.updateBrowserUrl(path);
      _handleUrlChange();
    }
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
        if (_currentProductScreen == ProductScreen.create ||
            _currentProductScreen == ProductScreen.edit ||
            _currentProductScreen == ProductScreen.bulkUpload) {
          _currentProductScreen = ProductScreen.list;
          _currentProductId = null;
          _updateBrowserUrl('/product');
          notifyListeners();
          return true;
        }
        return false;
      case AppScreen.client:
        if (_currentClientScreen == ClientScreen.create ||
            _currentClientScreen == ClientScreen.view ||
            _currentClientScreen == ClientScreen.edit ||
            _currentClientScreen == ClientScreen.bulkUpload) {
          _currentClientScreen = ClientScreen.list;
          _currentClientId = null;
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

  void navigateToProductScreen(ProductScreen screen, {String? productId}) {
    _currentProductScreen = screen;
    _currentProductId = productId;
    _currentScreen = AppScreen.product;

    var path = '/product';
    if (screen == ProductScreen.create) {
      path = '$path/create';
    } else if (screen == ProductScreen.edit && productId != null) {
      path = '$path/edit/$productId';
    } else if (screen == ProductScreen.bulkUpload) {
      path = '$path/bulk-upload';
    }

    _updateBrowserUrl(path);
    notifyListeners();
  }

  void navigateToClientScreen(ClientScreen screen, {String? clientId}) {
    _currentClientScreen = screen;
    _currentScreen = AppScreen.client;
    _currentClientId = clientId;

    String path = '/client';
    if (screen == ClientScreen.create) {
      path = '$path/create';
    } else if ((screen == ClientScreen.view || screen == ClientScreen.edit) &&
        clientId != null) {
      path = '$path/${screen == ClientScreen.edit ? 'edit/' : ''}$clientId';
    } else if (screen == ClientScreen.bulkUpload) {
      path = '$path/bulk-upload';
    }

    _updateBrowserUrl(path);
    notifyListeners();
  }

  void navigateToSettingsScreen(SettingsScreen screen) {
    _currentSettingsScreen = screen;
    _currentScreen = AppScreen.settings;
    _updateBrowserUrl(
        '/settings${screen == SettingsScreen.list ? '' : '/${screen.toString().split('.').last}'}');
    notifyListeners();
  }

  void navigateTo(AppScreen screen) {
    // Reset any sub-screen states when switching main screens
    switch (screen) {
      case AppScreen.invoice:
        _currentInvoiceScreen = InvoiceScreen.list;
        _currentInvoiceId = null;
        break;
      case AppScreen.product:
        _currentProductScreen = ProductScreen.list;
        _currentProductId = null;
        break;
      case AppScreen.client:
        _currentClientScreen = ClientScreen.list;
        _currentClientId = null;
        break;
      case AppScreen.settings:
        _currentSettingsScreen = SettingsScreen.list;
        break;
      default:
        break;
    }

    _currentScreen = screen;
    _updateBrowserUrl('/${screen.toString().split('.').last.toLowerCase()}');

    // Handle dashboard charts animation
    if (screen == AppScreen.dashboard && navigatorKey.currentContext != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (navigatorKey.currentContext != null) {
          Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                  listen: false)
              .onTabChanged();
        }
      });
    }

    notifyListeners();
  }

  void _updateNavigationState(String path) {
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
        final invoiceId = path.split('/').last;
        _currentInvoiceScreen = InvoiceScreen.view;
        _currentInvoiceId = invoiceId;
      }
    } else if (path.startsWith('/product')) {
      _currentScreen = AppScreen.product;

      if (path == '/product/create') {
        _currentProductScreen = ProductScreen.create;
        _currentProductId = null;
      } else if (path.contains('/edit/')) {
        _currentProductScreen = ProductScreen.edit;
        _currentProductId = path.split('/').last;
      } else if (path == '/product/bulk-upload') {
        _currentProductScreen = ProductScreen.bulkUpload;
        _currentProductId = null;
      } else {
        _currentProductScreen = ProductScreen.list;
        _currentProductId = null;
      }
    } else if (path.startsWith('/client')) {
      _currentScreen = AppScreen.client;

      if (path == '/client/create') {
        _currentClientScreen = ClientScreen.create;
        _currentClientId = null;
      } else if (path == '/client/bulk-upload') {
        _currentClientScreen = ClientScreen.bulkUpload;
        _currentClientId = null;
      } else if (path == '/client') {
        _currentClientScreen = ClientScreen.list;
        _currentClientId = null;
      } else if (path.contains('/edit/')) {
        final clientId = path.split('/').last;
        _currentClientScreen = ClientScreen.edit;
        _currentClientId = clientId;
      } else {
        final clientId = path.split('/').last;
        _currentClientScreen = ClientScreen.view;
        _currentClientId = clientId;
      }
    } else if (path.startsWith('/settings')) {
      _currentScreen = AppScreen.settings;
      if (path == '/settings') {
        _currentSettingsScreen = SettingsScreen.list;
      } else {
        final screenName = path.split('/').last;
        _currentSettingsScreen = SettingsScreen.values.firstWhere(
          (screen) =>
              screen.toString().split('.').last.toLowerCase() == screenName,
          orElse: () => SettingsScreen.list,
        );
      }
    }

    notifyListeners();
  }

  void clearNavigationState() {
    _currentScreen = AppScreen.dashboard;
    _currentInvoiceScreen = InvoiceScreen.list;
    _currentInvoiceId = null;
    _currentProductScreen = ProductScreen.list;
    _currentClientScreen = ClientScreen.list;
    _currentSettingsScreen = SettingsScreen.list;
    _currentClientId = null;
    _currentProductId = null;
    notifyListeners();
  }
}
