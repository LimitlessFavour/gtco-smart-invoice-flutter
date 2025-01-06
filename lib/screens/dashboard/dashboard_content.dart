import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../constants/styles.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/dashboard/payment_chart.dart';
import '../../widgets/dashboard/stats_card.dart';
import '../../widgets/dashboard/activity_card.dart';
import '../../widgets/dashboard/top_list_card.dart';
import '../../widgets/dashboard/invoice_stats_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF4F2),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Overview',
            size: 28,
            weight: FontWeight.w600,
          ),
          const Gap(24),
          // Wrap the main content in Expanded + SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column (65% width)
                    Expanded(
                      flex: 65,
                      child: Column(
                        children: [
                          // Remove Expanded from PaymentChart container
                          Container(
                            height: 400, // Fixed height instead of flex
                            decoration: AppStyles.cardDecoration,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const AppText(
                                      'Payments',
                                      size: 18,
                                      weight: FontWeight.w600,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          AppText(
                                            'Last 9 Month',
                                            color: Colors.grey[600],
                                            size: 14,
                                          ),
                                          const Gap(8),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.grey[600],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(24),
                                Expanded(
                                  child: PaymentChart(),
                                ),
                              ],
                            ),
                          ),
                          const Gap(24),
                          // Remove Expanded from Top Lists container
                          SizedBox(
                            height: 400, // Fixed height instead of flex
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
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
                                ),
                                const Gap(24),
                                Expanded(
                                  child: Container(
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                    // Right Column (35% width)
                    Expanded(
                      flex: 35,
                      child: Column(
                        children: [
                          // Remove Expanded from Stats Card
                          Container(
                            height: 300, // Fixed height instead of flex
                            decoration: AppStyles.cardDecoration,
                            child: const InvoiceStatsCard(),
                          ),
                          const Gap(24),
                          // Remove Expanded from Activity Card
                          Container(
                            height: 500, // Fixed height instead of flex
                            decoration: AppStyles.cardDecoration,
                            child: const ActivityCard(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
