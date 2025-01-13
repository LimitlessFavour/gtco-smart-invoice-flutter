import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:timelines/timelines.dart';
import 'package:gtco_smart_invoice_flutter/constants/styles.dart';
import '../common/app_text.dart';

class ActivityCard extends StatelessWidget {
  final bool isMobile;

  const ActivityCard({
    super.key,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Activity',
            size: isMobile ? 16 : 18,
            weight: FontWeight.w600,
          ),
          Gap(isMobile ? 16 : 24),
          Expanded(
            child: Timeline.tileBuilder(
              theme: TimelineThemeData(
                nodePosition: 0,
                connectorTheme: const ConnectorThemeData(
                  thickness: 1.0,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              builder: TimelineTileBuilder.connected(
                connectionDirection: ConnectionDirection.before,
                itemCount: 3,
                contentsBuilder: (_, index) {
                  return _buildTimelineCard(
                    getActivityData()[index],
                  );
                },
                indicatorBuilder: (_, index) {
                  final activity = getActivityData()[index];
                  return DotIndicator(
                    size: isMobile ? 24 : 32,
                    color: activity.color.withOpacity(0.1),
                    child: Icon(
                      activity.icon,
                      size: isMobile ? 12 : 16,
                      color: activity.color,
                    ),
                  );
                },
                connectorBuilder: (_, index, __) {
                  return const SolidLineConnector();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(ActivityItem activity) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMobile ? 12.0 : 16.0,
        bottom: isMobile ? 16.0 : 24.0,
      ),
      child: Container(
        margin: EdgeInsets.only(top: isMobile ? 4 : 8),
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFC6C1C1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              activity.title,
              weight: FontWeight.w600,
              size: isMobile ? 14 : 16,
            ),
            Gap(isMobile ? 2 : 4),
            AppText(
              activity.description,
              size: isMobile ? 12 : 14,
              color: Colors.grey[600],
            ),
            Gap(isMobile ? 6 : 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    activity.date,
                    size: isMobile ? 8 : 10,
                    color: Colors.grey[600],
                    weight: FontWeight.w600,
                  ),
                  Gap(isMobile ? 4 : 6),
                  AppText(
                    activity.time,
                    size: isMobile ? 8 : 10,
                    color: Colors.grey[600],
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ActivityItem> getActivityData() {
    return [
      ActivityItem(
        icon: Icons.send,
        color: Colors.green,
        title: 'Invoice Sent',
        description:
            'Invoice #1001 of amount N100,000 has been sent to Ire Victor with email irevirctor@gmail.com',
        time: '12:03AM',
        date: '11-02-2025',
      ),
      ActivityItem(
        icon: Icons.receipt,
        color: const Color(0xFFE04403),
        title: 'Invoice Generated',
        description:
            'Invoice #1001 of amount N300,000 has been generated and is read to be sent to Ire Victor.',
        time: '12:03AM',
        date: '11-02-2025',
      ),
      ActivityItem(
        icon: Icons.inventory_2_outlined,
        color: Colors.blue,
        title: 'Product Created',
        description:
            'A new product named Bag of Rice has been added to your product list',
        time: '12:03AM',
        date: '11-02-2025',
      ),
    ];
  }
}

class ActivityItem {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String time;
  final String date;

  ActivityItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
  });
}
