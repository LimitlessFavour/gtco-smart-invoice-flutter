import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  static bool isTabletScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 &&
        MediaQuery.of(context).size.width < 1024;
  }

  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }
}
