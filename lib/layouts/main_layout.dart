import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/layouts/web_main_layout.dart';
import '../utils/responsive_utils.dart';
import 'mobile_layout.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.isMobileScreen(context)
        ? const MobileLayout()
        : const DesktopLayout();
  }
}
