import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/widgets/dashboard/payment_chart.dart';
import '../../widgets/dashboard/stats_card.dart';
import '../../widgets/dashboard/activity_card.dart';
import '../../widgets/dashboard/top_list_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildPaymentsChart(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatsCard(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildListsRow(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: ActivityCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                DropdownButton<String>(
                  value: 'Last 9 Month',
                  items: const [
                    DropdownMenuItem(
                      value: 'Last 9 Month',
                      child: Text('Last 9 Month'),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: BarChart(
                createChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '₦500,000',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Invoiced'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Paid', Colors.green),
                const SizedBox(width: 16),
                _buildLegendItem('Unpaid', Colors.red),
                const SizedBox(width: 16),
                _buildLegendItem('Drafted', Colors.grey),
              ],
            ),
          ],
        ),
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
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildListsRow() {
    return Row(
      children: [
        Expanded(
          child: TopListCard(
            title: 'Top Paying Clients',
            items: List.generate(
              4,
              (index) => TopListItem(
                title: 'John Snow',
                value: '₦260,000',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TopListCard(
            title: 'Top Selling Products',
            items: List.generate(
              4,
              (index) => TopListItem(
                title: 'Bone Straight',
                value: '₦260,000',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
