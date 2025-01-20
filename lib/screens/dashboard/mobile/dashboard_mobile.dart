import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../constants/styles.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/dashboard/activity_card.dart';
import '../../../widgets/dashboard/invoice_stats_card.dart';
import '../../../widgets/dashboard/payment_chart.dart';
import '../../../widgets/dashboard/top_list_card.dart';
import '../../../widgets/dashboard/timeline_selector.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../widgets/common/loading_overlay.dart';

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: Container(
            color: const Color(0xFFFFF4F2),
            child: RefreshIndicator(
              onRefresh: () => provider.loadInitialData(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        provider.loadInitialData();
                      },
                      child: const AppText(
                        'Overview',
                        size: 24,
                        weight: FontWeight.w600,
                      ),
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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                'Payments',
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                              TimelineSelector(
                                isMobile: true,
                                type: TimelineType.payments,
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
                      child: Consumer<DashboardProvider>(
                        builder: (context, provider, _) {
                          final clients =
                              provider.analytics?.topPayingClients ?? [];
                          return TopListCard(
                            title: 'Top Paying Clients',
                            items: clients
                                .map((client) => TopListItem(
                                      title: client.fullName,
                                      value:
                                          '₦${NumberFormat("#,##0").format(client.totalPaid)}',
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                    const Gap(16),

                    // Top Selling Products
                    Container(
                      height: 300,
                      decoration: AppStyles.cardDecoration,
                      child: Consumer<DashboardProvider>(
                        builder: (context, provider, _) {
                          final products =
                              provider.analytics?.topSellingProducts ?? [];
                          return TopListCard(
                            title: 'Top Selling Products',
                            items: products
                                .map((product) => TopListItem(
                                      title: product.name,
                                      value:
                                          '₦${NumberFormat("#,##0").format(product.totalAmount)}',
                                    ))
                                .toList(),
                          );
                        },
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
            ),
          ),
        );
      },
    );
  }
}
