import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../common/app_text.dart';

class NoResultsFoundState extends StatelessWidget {
  final bool isMobile;

  const NoResultsFoundState({
    super.key,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_invoice.png',
            height: isMobile ? 120 : 160,
            width: isMobile ? 90 : 120,
          ),
          const Gap(24),
          const AppText(
            'No matches found',
            size: 20,
            weight: FontWeight.w600,
          ),
          const Gap(8),
          AppText(
            'Try adjusting your search or filter to find what you\'re looking for.',
            size: 14,
            color: Colors.grey[600],
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
