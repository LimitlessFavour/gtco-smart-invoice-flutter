import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../common/app_text.dart';

class FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              icon,
              height: 48,
              width: 48,
            ),
            const Gap(16),
            AppText.heading(
              title,
              size: 20,
            ),
            const Gap(8),
            AppText(
              description,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
} 