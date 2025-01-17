import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice_item.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';

class InvoiceContentView extends StatelessWidget {
  final Invoice invoice;

  const InvoiceContentView({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC6C1C1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            _buildFromToSection(),
            const Gap(48),
            _buildProductsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/bee_daisy_logo.png',
            height: 48,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Date: ${_formatDate(invoice.createdAt)}',
                style: const TextStyle(color: Color(0xFF667085)),
              ),
              const Gap(4),
              Text(
                'Due Date: ${_formatDate(invoice.dueDate)}',
                style: const TextStyle(color: Color(0xFF667085)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFromToSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildFromSection(),
          ),
          Expanded(
            child: _buildToSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildFromSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        AppText(
          'From:',
          color: Color(0xFFE04403),
          weight: FontWeight.w500,
        ),
        Gap(8),
        AppText('Bee Daisy Hair & Merchandise'),
        AppText('+234 905 691 8846'),
        AppText('12b Emma Abimbola Cole'),
        Text('Street, Lekki phase1'),
        Text('beedaisyhair@gmail.com'),
      ],
    );
  }

  Widget _buildToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'To:',
          color: Color(0xFFE04403),
          weight: FontWeight.w500,
        ),
        const Gap(8),
        AppText('${invoice.client.firstName} ${invoice.client.lastName}'),
        AppText(invoice.client.phoneNumber),
        AppText(invoice.client.address),
        AppText(invoice.client.email),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(),
          ...invoice.items.map(_buildTableRow),
          const Gap(24),
          _buildTotalSection(),
        ],
      ),
    );
  }

  // Helper methods (moved from original file)
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildTableHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'PRODUCT',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF667085),
            ),
          ),
        ),
        Expanded(
          child: Text(
            'PRICE',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF667085),
            ),
          ),
        ),
        Expanded(
          child: Text(
            'QTY',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF667085),
            ),
          ),
        ),
        Expanded(
          child: Text(
            'TOTAL',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF667085),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(InvoiceItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              item.productName ?? 'Product',
              size: 14,
            ),
          ),
          Expanded(
            child: AppText(
              '₦${item.price.toStringAsFixed(2)}',
              size: 14,
            ),
          ),
          Expanded(
            child: AppText(
              item.quantity.toString(),
              size: 14,
            ),
          ),
          Expanded(
            child: AppText(
              '₦${(item.price * item.quantity).toStringAsFixed(2)}',
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Column(
      children: [
        _buildTotalRow(
          'Sub Total',
          '₦${invoice.totalAmount.toStringAsFixed(2)}',
        ),
        _buildTotalRow('Discount', '-'),
        _buildTotalRow('VAT', '-'),
        const Divider(),
        _buildTotalRow(
          'Total',
          '₦${invoice.totalAmount.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
