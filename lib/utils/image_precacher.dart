import 'package:flutter/material.dart';

class ImagePrecacher {
  static final List<String> _imagesToPrecache = [
    // Auth backgrounds
    'assets/images/background.png',
    'assets/images/background_mobile.png',
    // Landing page images
    'assets/images/landing_hero.png',
    // Other common images
    'assets/images/receipt.png',
    'assets/images/google.png',
  ];

  static Future<void> precacheImages(BuildContext context) async {
    for (final imagePath in _imagesToPrecache) {
      await precacheImage(AssetImage(imagePath), context);
    }
  }
} 