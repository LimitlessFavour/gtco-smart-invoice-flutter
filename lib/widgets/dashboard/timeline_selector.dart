import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../common/app_text.dart';

enum TimelineType { payments, invoices }

class TimelineSelector extends StatelessWidget {
  final bool isMobile;
  final TimelineType type;

  const TimelineSelector({
    super.key,
    this.isMobile = false,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        final selectedTimeline = type == TimelineType.payments
            ? provider.paymentsTimeline
            : provider.invoicesTimeline;

        return PopupMenuButton<String>(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12,
              vertical: isMobile ? 4 : 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                AppText(
                  _getTimelineLabel(selectedTimeline),
                  color: Colors.grey[600],
                  size: isMobile ? 12 : 14,
                ),
                Gap(isMobile ? 4 : 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                  size: isMobile ? 16 : 24,
                ),
              ],
            ),
          ),
          itemBuilder: (context) => [
            _buildMenuItem('LAST_WEEK', 'Last Week'),
            _buildMenuItem('LAST_MONTH', 'Last Month'),
            _buildMenuItem('LAST_3_MONTHS', 'Last 3 Months'),
            _buildMenuItem('LAST_6_MONTHS', 'Last 6 Months'),
            _buildMenuItem('LAST_9_MONTHS', 'Last 9 Months'),
            _buildMenuItem('LAST_12_MONTHS', 'Last 12 Months'),
          ],
          onSelected: (value) => type == TimelineType.payments
              ? provider.updatePaymentsTimeline(value)
              : provider.updateInvoicesTimeline(value),
        );
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, String label) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(label),
    );
  }

  String _getTimelineLabel(String timeline) {
    switch (timeline) {
      case 'LAST_WEEK':
        return 'Last Week';
      case 'LAST_MONTH':
        return 'Last Month';
      case 'LAST_3_MONTHS':
        return 'Last 3 Months';
      case 'LAST_6_MONTHS':
        return 'Last 6 Months';
      case 'LAST_9_MONTHS':
        return 'Last 9 Months';
      case 'LAST_12_MONTHS':
        return 'Last 12 Months';
      default:
        return 'Last 9 Months';
    }
  }
}
