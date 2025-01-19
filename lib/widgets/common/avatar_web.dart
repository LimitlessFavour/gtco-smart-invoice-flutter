import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Widget buildPlatformAvatar({
  required String imageUrl,
  required double width,
  required double height,
}) {
  // Create a unique ID for this view
  final viewId = 'web-avatar-${DateTime.now().millisecondsSinceEpoch}';

  // Create and configure the image element
  final img = html.ImageElement()
    ..src = imageUrl
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.objectFit = 'cover';

  // Register the view
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) => img);

  return SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(
      viewType: viewId,
    ),
  );
}
