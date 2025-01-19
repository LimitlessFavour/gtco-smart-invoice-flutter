import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fl_chart/fl_chart.dart';
import '../common/app_text.dart';
import '../common/app_empty_state.dart';

class PaymentChartEmptyState extends StatelessWidget {
  const PaymentChartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Custom bar chart empty state with animated bars
                  SizedBox(
                    height: 180, // Reduced height
                    child: Stack(
                      children: [
                        // Background grid lines
                        CustomPaint(
                          size: const Size(double.infinity, 180),
                          painter: GridPainter(),
                        ),
                        // Empty bars
                        BarChart(
                          BarChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final months = [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun'
                                    ];
                                    if (value >= 0 && value < months.length) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: AppText(
                                          months[value.toInt()],
                                          color: Colors.grey[400],
                                          size: 12,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: AppText(
                                        '${value.toInt()}K',
                                        color: Colors.grey[400],
                                        size: 12,
                                      ),
                                    );
                                  },
                                  interval: 2,
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            maxY: 10,
                            barGroups: List.generate(
                              6,
                              (index) => BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: [3, 5, 4, 6, 4, 5][index].toDouble(),
                                    color: theme.primaryColor.withOpacity(0.1),
                                    width: 30,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  AppEmptyState(
                    header: 'No payment data available',
                    message: 'Start creating invoices to track your payments',
                    iconColor: theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for grid lines
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (var i = 0; i <= 5; i++) {
      final y = (size.height / 5) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TopPayingClientsEmptyState extends StatelessWidget {
  const TopPayingClientsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppEmptyState(
      header: 'No paying clients yet',
      message:
          'Create invoices to track your top clients',
      iconColor: theme.primaryColor,
    );
  }
}

class TopSellingProductsEmptyState extends StatelessWidget {
  const TopSellingProductsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppEmptyState(
      header: 'No products sold yet',
      message:
          'Add products and create invoices to track sales',
      iconColor: theme.primaryColor,
    );
  }
}
