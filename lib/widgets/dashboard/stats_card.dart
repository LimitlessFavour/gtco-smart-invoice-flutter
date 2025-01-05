import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/app_text.dart';

class StatsCard extends StatelessWidget {
  final String icon;
  final String amount;
  final String label;
  final Color? iconColor;

  const StatsCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              iconColor ?? Theme.of(context).primaryColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 12),
          AppText(
            amount,
            size: 24,
            weight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          AppText(
            label,
            size: 14,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }
} 