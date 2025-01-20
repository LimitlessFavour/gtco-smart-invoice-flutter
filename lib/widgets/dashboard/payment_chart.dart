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

  bool _hasSignificantPayments(List<DashboardTransaction> payments) {
    return payments.any((payment) => payment.amount > 0);
  }

  Map<String, double> _aggregatePaymentsByDate(
      List<DashboardTransaction> transactions, String timeline) {
    final Map<String, double> aggregatedData = {};
    final now = DateTime.now();

    // Define the start date based on the timeline
    DateTime startDate;
    String dateFormat;

    switch (timeline) {
      case 'LAST_WEEK':
        startDate = now.subtract(const Duration(days: 7));
        dateFormat = 'dd/MM'; // Day/Month format
        break;
      case 'LAST_MONTH':
        startDate = now.subtract(const Duration(days: 30));
        dateFormat = 'W'; // Week number format
        break;
      case 'LAST_3_MONTHS':
        startDate = DateTime(now.year, now.month - 3, now.day);
        dateFormat = 'MMM'; // Month name format
        break;
      case 'LAST_6_MONTHS':
        startDate = DateTime(now.year, now.month - 6, now.day);
        dateFormat = 'MMM';
        break;
      case 'LAST_9_MONTHS':
        startDate = DateTime(now.year, now.month - 9, now.day);
        dateFormat = 'MMM';
        break;
      case 'LAST_12_MONTHS':
        startDate = DateTime(now.year - 1, now.month, now.day);
        dateFormat = 'MMM';
        break;
      default:
        startDate = DateTime(now.year, now.month - 9, now.day);
        dateFormat = 'MMM';
    }

    // Filter transactions within the time range
    final filteredTransactions = transactions
        .where((transaction) =>
            transaction.createdAt.isAfter(startDate) &&
            transaction.createdAt.isBefore(now.add(const Duration(days: 1))))
        .toList();

    // Initialize periods based on timeline
    if (timeline == 'LAST_WEEK') {
      // For last week, show each day in ascending order
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        aggregatedData[DateFormat(dateFormat).format(date)] = 0;
      }
    } else if (timeline == 'LAST_MONTH') {
      // For last month, show weeks
      for (int i = 4; i >= 1; i--) {
        aggregatedData['Week $i'] = 0;
      }
    } else {
      // For months, initialize each month
      for (int i = 0; i < 12; i++) {
        final date = DateTime(now.year, now.month - i, 1);
        if (date.isAfter(startDate)) {
          aggregatedData[DateFormat(dateFormat).format(date)] = 0;
        }
      }
    }

    // Aggregate transactions
    for (var transaction in filteredTransactions) {
      final date = transaction.createdAt;
      String key;

      if (timeline == 'LAST_WEEK') {
        key = DateFormat(dateFormat).format(date);
      } else if (timeline == 'LAST_MONTH') {
        // Calculate week number within the month
        final weekNumber = ((date.day - 1) / 7).floor() + 1;
        key = 'Week $weekNumber';
      } else {
        key = DateFormat(dateFormat).format(date);
      }

      if (aggregatedData.containsKey(key)) {
        aggregatedData[key] = (aggregatedData[key] ?? 0) + transaction.amount;
      }
    }

    // For weekly view, return entries in ascending order (earlier dates first)
    // For other views, keep the current reverse order
    if (timeline == 'LAST_WEEK') {
      return aggregatedData;
    } else {
      return Map.fromEntries(aggregatedData.entries.toList().reversed);
    }
  }

  double _calculateMaxY(List<double> values) {
    if (values.isEmpty) return 500000; // Default 500K if no data
    final max = values.reduce((a, b) => a > b ? a : b);
    // Round up to the nearest 100K
    return ((max / 100000).ceil() * 100000).toDouble();
  }

  String _formatYAxisLabel(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
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

        final aggregatedData = _aggregatePaymentsByDate(
          analytics.paymentsTimeline,
          provider.paymentsTimeline,
        );
        final labels = aggregatedData.keys.toList();
        final values = aggregatedData.values.toList();
        final maxY = _calculateMaxY(values);

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth / (labels.length * 2.5);

                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    minY: 0,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipRoundedRadius: 8,
                        tooltipPadding: const EdgeInsets.all(8),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '₦${NumberFormat("#,##0").format(values[group.x.toInt()])}',
                            const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value >= 0 && value < labels.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: AppText(
                                  labels[value.toInt()],
                                  color: Colors.grey[600],
                                  size: 12,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxY / 5, // Show 5 intervals
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AppText(
                                _formatYAxisLabel(value),
                                color: Colors.grey[600],
                                size: 12,
                              ),
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
                      horizontalInterval: maxY / 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[200],
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                        left: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    barGroups: values.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value * _animation.value,
                            color: const Color(0xFFE04403),
                            width: barWidth,
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
}
