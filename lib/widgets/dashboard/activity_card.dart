import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/constants/styles.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import '../../providers/dashboard_provider.dart';
import '../../utils/activity_mapper.dart';
import '../common/app_text.dart';

class ActivityCard extends StatelessWidget {
  final bool isMobile;

  const ActivityCard({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && !provider.initialLoadComplete) {
          return const Center(child: CircularProgressIndicator());
        }

        final activities = provider.analytics?.activities ?? [];

        if (activities.isEmpty) {
          return const Center(
            child: AppText(
              'No activities yet',
              color: Colors.grey,
            ),
          );
        }

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
                    itemCount: activities.length,
                    contentsBuilder: (_, index) {
                      final activity = activities[index];
                      final activityItem =
                          ActivityMapper.mapToActivityItem(activity);
                      return _buildTimelineCard(activityItem);
                    },
                    indicatorBuilder: (_, index) {
                      final activity = activities[index];
                      final activityItem =
                          ActivityMapper.mapToActivityItem(activity);
                      return DotIndicator(
                        size: isMobile ? 24 : 32,
                        color: activityItem.color.withOpacity(0.1),
                        child: Icon(
                          activityItem.icon,
                          size: isMobile ? 14 : 22,
                          color: activityItem.color,
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
      },
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
