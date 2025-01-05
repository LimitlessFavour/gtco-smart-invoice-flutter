import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarChartData createChartData() {
  return BarChartData(
    barGroups: [
      _createBarGroup(0, 150000, 'May'),
      _createBarGroup(1, 300000, 'Jun'),
      _createBarGroup(2, 100000, 'Jul'),
      _createBarGroup(3, 200000, 'Aug'),
      _createBarGroup(4, 450000, 'Sep'),
      _createBarGroup(5, 300000, 'Oct'),
      _createBarGroup(6, 400000, 'Nov'),
      _createBarGroup(7, 500000, 'Dec'),
      _createBarGroup(8, 150000, 'Jan'),
    ],
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text('${(value / 1000).toInt()}K');
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const months = [
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec',
              'Jan'
            ];
            return Text(months[value.toInt()]);
          },
        ),
      ),
    ),
    gridData: FlGridData(show: true),
    borderData: FlBorderData(show: false),
  );
}

BarChartGroupData _createBarGroup(int x, double value, String label) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: value,
        color: const Color(0xFFE84C3D),
        width: 16,
        borderRadius: BorderRadius.circular(4),
      ),
    ],
  );
}
