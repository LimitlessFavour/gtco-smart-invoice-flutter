import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/models/dashboard_analytics.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import 'package:intl/intl.dart';
import 'dashboard_empty_states.dart';

class PaymentChart extends StatefulWidget {
  const PaymentChart({super.key});

  @override
  State<PaymentChart> createState() => _PaymentChartState();
}

class _PaymentChartState extends State<PaymentChart>
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

  bool _hasSignificantPayments(List<PaymentsByMonth> payments) {
    // Check if there's any payment with an amount greater than 0
    return payments.any((payment) => payment.amount > 0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && !provider.initialLoadComplete) {
          return const Center(child: CircularProgressIndicator());
        }

        final analytics = provider.analytics;
        if (analytics == null ||
            !_hasSignificantPayments(analytics.paymentsTimeline)) {
          return const PaymentChartEmptyState();
        }

        if (provider.shouldAnimatePayments &&
            !_animationController.isAnimating) {
          _animationController.reset();
          _animationController.forward();
        }

        final timelineData = analytics.paymentsTimeline;
        final months =
            _getOrderedMonths(timelineData, provider.paymentsTimeline);

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: timelineData.isEmpty
                        ? 100 // Default max if no data
                        : timelineData
                            .map((p) => p.amount)
                            .reduce((a, b) => a > b ? a : b),
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value >= 0 && value < months.length) {
                              return AppText(
                                months[value.toInt()],
                                color: Colors.grey[600],
                                size: 12,
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return AppText(
                              '${(value / 1000).toInt()}K',
                              color: Colors.grey[600],
                              size: 12,
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 100000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups:
                        analytics.paymentsTimeline.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.amount * _animation.value,
                            color: const Color(0xFFE04403),
                            width: constraints.maxWidth / 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<String> _getOrderedMonths(List<PaymentsByMonth> data, String timeline) {
    final now = DateTime.now();
    final months = <String>[];

    switch (timeline) {
      case 'LAST_WEEK':
        // Generate last 7 days
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          months.add('${date.day}/${date.month}');
        }
        break;
      case 'LAST_MONTH':
        // Generate last 4 weeks
        for (int i = 3; i >= 0; i--) {
          final date = now.subtract(Duration(days: i * 7));
          months.add('Week ${4 - i}');
        }
        break;
      default:
        // Generate months based on timeline duration
        final monthCount = int.parse(timeline.split('_')[1]);
        for (int i = monthCount - 1; i >= 0; i--) {
          final date = DateTime(now.year, now.month - i);
          months.add(DateFormat('MMM').format(date));
        }
    }

    return months;
  }
}
