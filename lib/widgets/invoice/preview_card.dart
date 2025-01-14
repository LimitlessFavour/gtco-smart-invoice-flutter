import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../common/app_text.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/gtco_logo.png',
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText.heading('INVOICE', size: 24),
                    AppText('#INV-001', color: Colors.grey[600]),
                  ],
                ),
              ],
            ),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(
                  'From',
                  'Your Company Name',
                  'your.email@example.com\n+234 905 691 8846',
                ),
                _buildInfoSection(
                  'Bill To',
                  'Customer Name',
                  'customer@example.com\n+234 123 456 7890',
                ),
              ],
            ),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateInfo('Invoice Date', '12 Mar 2024'),
                _buildDateInfo('Due Date', '19 Mar 2024'),
              ],
            ),
            const Gap(32),
            const Divider(),
            const Gap(16),
            _buildItemsTable(),
            const Gap(32),
            const Divider(),
            const Gap(16),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String name, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, color: Colors.grey[600]),
        const Gap(8),
        AppText(name, weight: FontWeight.w600),
        const Gap(4),
        AppText(details, size: 14),
      ],
    );
  }

  Widget _buildDateInfo(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, color: Colors.grey[600], size: 14),
        const Gap(4),
        AppText(date, weight: FontWeight.w500),
      ],
    );
  }

  Widget _buildItemsTable() {
    return Column(
      children: [
        _buildTableHeader(),
        const Gap(16),
        _buildTableRow('Website Design', 1, 50000),
        const Gap(8),
        _buildTableRow('Mobile App Development', 1, 100000),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppText('Item', color: Colors.grey[600], size: 14),
        ),
        Expanded(
          child: AppText('Qty', color: Colors.grey[600], size: 14),
        ),
        Expanded(
          child: AppText('Price', color: Colors.grey[600], size: 14),
        ),
        Expanded(
          child: AppText('Total', color: Colors.grey[600], size: 14),
        ),
      ],
    );
  }

  Widget _buildTableRow(String item, int qty, double price) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppText(item, weight: FontWeight.w500),
        ),
        Expanded(
          child: AppText(qty.toString()),
        ),
        Expanded(
          child: AppText('₦${price.toStringAsFixed(2)}'),
        ),
        Expanded(
          child: AppText('₦${(qty * price).toStringAsFixed(2)}'),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Column(
      children: [
        _buildTotalRow('Subtotal', '₦150,000.00'),
        const Gap(8),
        _buildTotalRow('VAT (7.5%)', '₦11,250.00'),
        const Gap(8),
        _buildTotalRow('Total', '₦161,250.00', isTotal: true),
      ],
    );
  }

  Widget _buildTotalRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          color: isTotal ? Colors.black : Colors.grey[600],
          weight: isTotal ? FontWeight.w600 : FontWeight.normal,
        ),
        AppText(
          amount,
          weight: isTotal ? FontWeight.w600 : FontWeight.normal,
        ),
      ],
    );
  }
}
