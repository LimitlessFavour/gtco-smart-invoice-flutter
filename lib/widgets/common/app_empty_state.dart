import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../common/app_text.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
    this.iconColor,
    this.header,
  });

  final String? header;
  final String message;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/receipt.png',
            height: 48,
            width: 48,
            color: theme.primaryColor,
          ),
          const Gap(16),
          if (header != null)
            AppText(
              header ?? '',
              color: const Color(0xFF6A6A6A),
              size: 16,
              weight: FontWeight.w600,
            ),
          if (header != null) const Gap(8),
          AppText(
            message,
            color: Colors.grey[600],
            textAlign: TextAlign.center,
            size: 14,
          ),
        ],
      ),
    );
  }
}
