import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/dashboard/timeline_selector.dart';

import '../../constants/styles.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/dashboard/activity_card.dart';
import '../../widgets/dashboard/invoice_stats_card.dart';
import '../../widgets/dashboard/payment_chart.dart';
import '../../widgets/dashboard/top_list_card.dart';

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
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      'Payments',
                                      size: 18,
                                      weight: FontWeight.w600,
                                    ),
                                    TimelineSelector(
                                      isMobile: false,
                                      type: TimelineType.payments,
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
                            height: 400,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: AppStyles.cardDecoration,
                                    child: const TopListCard(
                                      title: 'Top Paying Clients',
                                      items: [
                                        TopListItem(
                                          title: 'Sarah Johnson',
                                          value: '₦485,000',
                                        ),
                                        TopListItem(
                                          title: 'Michael Chen',
                                          value: '₦362,000',
                                        ),
                                        TopListItem(
                                          title: 'Aisha Patel',
                                          value: '₦298,500',
                                        ),
                                        TopListItem(
                                          title: 'David Williams',
                                          value: '₦245,000',
                                        ),
                                        TopListItem(
                                          title: 'Elena Rodriguez',
                                          value: '₦189,000',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(24),
                                Expanded(
                                  child: Container(
                                    decoration: AppStyles.cardDecoration,
                                    child: const TopListCard(
                                      title: 'Top Selling Products',
                                      items: [
                                        TopListItem(
                                          title: 'Premium Hair Bundle',
                                          value: '₦520,000',
                                        ),
                                        TopListItem(
                                          title: 'Silk Base Closure',
                                          value: '₦385,000',
                                        ),
                                        TopListItem(
                                          title: 'Brazilian Wave',
                                          value: '₦342,000',
                                        ),
                                        TopListItem(
                                          title: 'Lace Frontal Wig',
                                          value: '₦278,000',
                                        ),
                                        TopListItem(
                                          title: 'Deep Wave Bundle',
                                          value: '₦195,000',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(24),
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
                          const Gap(24),
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
