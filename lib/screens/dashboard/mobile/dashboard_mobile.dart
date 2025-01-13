import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../constants/styles.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/dashboard/activity_card.dart';
import '../../../widgets/dashboard/invoice_stats_card.dart';
import '../../../widgets/dashboard/payment_chart.dart';
import '../../../widgets/dashboard/top_list_card.dart';

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF4F2),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Overview',
              size: 24,
              weight: FontWeight.w600,
            ),
            const Gap(16),

            // Payments Chart
            Container(
              height: 350,
              decoration: AppStyles.cardDecoration,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        'Payments',
                        size: 16,
                        weight: FontWeight.w600,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            AppText(
                              'Last 9 Month',
                              color: Colors.grey[600],
                              size: 12,
                            ),
                            const Gap(4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Expanded(
                    child: PaymentChart(),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Invoice Stats
            Container(
              height: 250,
              decoration: AppStyles.cardDecoration,
              child: const InvoiceStatsCard(isMobile: true),
            ),
            const Gap(16),

            // Top Paying Clients
            Container(
              height: 300,
              decoration: AppStyles.cardDecoration,
              child: TopListCard(
                title: 'Top Paying Clients',
                items: List.generate(
                  4,
                  (index) => TopListItem(
                    title: 'John Snow',
                    value: '₦260,000',
                  ),
                ),
              ),
            ),
            const Gap(16),

            // Top Selling Products
            Container(
              height: 300,
              decoration: AppStyles.cardDecoration,
              child: TopListCard(
                title: 'Top Selling Products',
                items: List.generate(
                  4,
                  (index) => TopListItem(
                    title: 'Bone Straight',
                    value: '₦260,000',
                  ),
                ),
              ),
            ),
            const Gap(16),

            // Activity Card
            Container(
              height: 400,
              decoration: AppStyles.cardDecoration,
              child: const ActivityCard(isMobile: true),
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}
