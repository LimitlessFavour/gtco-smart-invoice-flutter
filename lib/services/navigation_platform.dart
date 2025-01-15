abstract class NavigationPlatform {
  void initializeHistory({Function? handleUrlChange});
  String getCurrentPath();
  void updateBrowserUrl(String path);
}
