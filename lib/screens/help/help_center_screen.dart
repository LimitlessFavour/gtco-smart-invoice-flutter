import 'package:flutter/material.dart';
import '../../layouts/responsive_layout.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      title: 'Help Center',
      child: Center(
        child: Text('Help Center - Coming Soon'),
      ),
    );
  }
}
