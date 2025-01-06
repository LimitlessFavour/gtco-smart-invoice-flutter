import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';

class InvoiceStatsCard extends StatelessWidget {
  const InvoiceStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/invoice.svg',
                width: 24,
                height: 24,
              ),
              const Gap(12),
              const AppText(
                'Invoices',
                size: 18,
                weight: FontWeight.w600,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    AppText(
                      'This Month',
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
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 60,
                        sections: [
                          PieChartSectionData(
                            value: 40,
                            color: Colors.green,
                            radius: 20,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 50,
                            color: const Color(0xFFE84C3D),
                            radius: 20,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 10,
                            color: Colors.grey,
                            radius: 20,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppText(
                        '₦500,000',
                        size: 24,
                        weight: FontWeight.bold,
                      ),
                      AppText(
                        'Invoiced',
                        color: Colors.grey[600],
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Paid', Colors.green),
              const Gap(16),
              _buildLegendItem('Unpaid', const Color(0xFFE84C3D)),
              const Gap(16),
              _buildLegendItem('Drafted', Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(4),
        AppText(
          label,
          size: 14,
          color: Colors.grey[600],
        ),
      ],
    );
  }
} 