import 'dart:html' as html;

import 'navigation_platform.dart';

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