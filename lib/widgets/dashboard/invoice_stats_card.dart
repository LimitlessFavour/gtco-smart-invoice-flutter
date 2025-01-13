import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';

class InvoiceStatsCard extends StatelessWidget {
  final bool isMobile;

  const InvoiceStatsCard({
    super.key,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/invoice.svg',
                width: isMobile ? 20 : 24,
                height: isMobile ? 20 : 24,
              ),
              Gap(isMobile ? 8 : 12),
              AppText(
                'Invoices',
                size: isMobile ? 16 : 18,
                weight: FontWeight.w600,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 12,
                  vertical: isMobile ? 4 : 8,
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
                      size: isMobile ? 12 : 14,
                    ),
                    Gap(isMobile ? 4 : 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: isMobile ? 16 : 24,
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
                    width: isMobile ? 120 : 160,
                    height: isMobile ? 120 : 160,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: isMobile ? 45 : 60,
                        sections: [
                          PieChartSectionData(
                            value: 40,
                            color: Colors.green,
                            radius: isMobile ? 15 : 20,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 50,
                            color: const Color(0xFFE04403),
                            radius: isMobile ? 15 : 20,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 10,
                            color: Colors.grey,
                            radius: isMobile ? 15 : 20,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        '₦500,000',
                        size: isMobile ? 18 : 24,
                        weight: FontWeight.bold,
                      ),
                      AppText(
                        'Invoiced',
                        color: Colors.grey[600],
                        size: isMobile ? 12 : 14,
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
              Gap(isMobile ? 12 : 16),
              _buildLegendItem('Unpaid', const Color(0xFFE04403)),
              Gap(isMobile ? 12 : 16),
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
          width: isMobile ? 8 : 12,
          height: isMobile ? 8 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Gap(isMobile ? 2 : 4),
        AppText(
          label,
          size: isMobile ? 12 : 14,
          color: Colors.grey[600],
        ),
      ],
    );
  }
}
