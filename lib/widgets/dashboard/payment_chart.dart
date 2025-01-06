import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PaymentChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 500000,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const months = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];
                    if (value >= 0 && value < months.length) {
                      return Text(
                        months[value.toInt()],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
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
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${(value / 1000).toInt()}K',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
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
              horizontalInterval: 100000,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[300],
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              150000, 300000, 100000, 200000, 450000, 300000, 400000, 500000, 150000,
            ].asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: const Color(0xFFE84C3D),
                    width: constraints.maxWidth / 20,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
