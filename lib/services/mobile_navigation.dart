import 'navigation_platform.dart';

class MobileNavigation implements NavigationPlatform {
  @override
  void initializeHistory({Function? handleUrlChange}) {}

  @override
  String getCurrentPath() => '/';

  @override
  void updateBrowserUrl(String path) {}
}

NavigationPlatform createNavigationPlatform() => MobileNavigation();