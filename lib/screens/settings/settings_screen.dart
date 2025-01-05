import 'package:flutter/material.dart';
import '../../layouts/responsive_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      title: 'Settings',
      child: Center(
        child: Text('Settings Screen - Coming Soon'),
      ),
    );
  }
} 