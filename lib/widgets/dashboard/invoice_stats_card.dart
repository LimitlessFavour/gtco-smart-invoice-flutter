import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtco_smart_invoice_flutter/services/logger_service.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/loading_overlay.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../common/app_text.dart';
import 'timeline_selector.dart';

class InvoiceStatsCard extends StatefulWidget {
  final bool isMobile;

  const InvoiceStatsCard({
    super.key,
    this.isMobile = false,
  });

  @override
  State<InvoiceStatsCard> createState() => _InvoiceStatsCardState();
}

class _InvoiceStatsCardState extends State<InvoiceStatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && !provider.initialLoadComplete) {
          return const Center(child: CommonProgressIndicator());
        }

        final analytics = provider.analytics;
        if (analytics == null) {
          return const Center(child: AppText('No data available'));
        }

        //log analytics
        LoggerService.info('Analytics: ${analytics.toJson()}');
        LoggerService.info(
          '''Analytics invoice stats: ${analytics.invoiceStats.toJson()}
          total invoiced: ${analytics.invoiceStats.totalInvoiced}
          paid: ${analytics.invoiceStats.paid}
          unpaid: ${analytics.invoiceStats.unpaid}
          drafted: ${analytics.invoiceStats.drafted}
          ''',
        );


        if (provider.shouldAnimateInvoices &&
            !_animationController.isAnimating) {
          _animationController.reset();
          _animationController.forward();
        }

        return Padding(
          padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppText(
                    'Invoices',
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                  const Spacer(),
                  TimelineSelector(
                    isMobile: widget.isMobile,
                    type: TimelineType.invoices,
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return PieChart(
                          swapAnimationCurve: Curves.easeInOut,
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: widget.isMobile ? 45 : 60,
                            sections: [
                              PieChartSectionData(
                                value: analytics.invoiceStats.paid *
                                    _animation.value,
                                color: Colors.green,
                                radius: widget.isMobile ? 15 : 20,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: analytics.invoiceStats.unpaid *
                                    _animation.value,
                                color: const Color(0xFFE04403),
                                radius: widget.isMobile ? 15 : 20,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: analytics.invoiceStats.drafted *
                                    _animation.value,
                                color: Colors.grey,
                                radius: widget.isMobile ? 15 : 20,
                                showTitle: false,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          '₦${NumberFormat("#,##0").format(analytics.invoiceStats.totalInvoiced)}',
                          maxLines: 1,
                          style: GoogleFonts.urbanist(
                            fontSize: widget.isMobile ? 14 : 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(4),
                        AppText(
                          'Total',
                          size: widget.isMobile ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Paid', Colors.green),
                  Gap(widget.isMobile ? 12 : 16),
                  _buildLegendItem('Unpaid', const Color(0xFFE04403)),
                  Gap(widget.isMobile ? 12 : 16),
                  _buildLegendItem('Drafted', Colors.grey),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(4),
        AppText(
          label,
          size: widget.isMobile ? 12 : 14,
          color: Colors.grey[600],
        ),
      ],
    );
  }
}
