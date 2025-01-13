abstract class NavigationPlatform {
  void initializeHistory({Function? handleUrlChange});
  String getCurrentPath();
  void updateBrowserUrl(String path);
}

class MobileNavigation implements NavigationPlatform {
  @override
  void initializeHistory({Function? handleUrlChange}) {}

  @override
  String getCurrentPath() => '/';

  @override
  void updateBrowserUrl(String path) {}
}

NavigationPlatform createNavigationPlatform() => MobileNavigation();
