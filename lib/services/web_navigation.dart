import 'dart:html' as html;

import 'package:gtco_smart_invoice_flutter/services/mobile_navigation.dart';

class WebNavigation implements NavigationPlatform {
  @override
  void initializeHistory({Function? handleUrlChange}) {
    if (handleUrlChange != null) {
      html.window.onPopState.listen((_) => handleUrlChange());
    }
  }

  @override
  String getCurrentPath() {
    return html.window.location.pathname ?? '/';
  }

  @override
  void updateBrowserUrl(String path) {
    html.window.history.pushState(null, '', path);
  }
}

NavigationPlatform createNavigationPlatform() => WebNavigation();
