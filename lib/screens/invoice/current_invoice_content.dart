import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice_item.dart';
import '../../models/invoice.dart';
import '../../widgets/common/app_text.dart';
import '../../services/navigation_service.dart';
import 'package:provider/provider.dart';

class CurrentInvoiceContent extends StatelessWidget {
  final Invoice invoice;

  const CurrentInvoiceContent({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with actions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFC6C1C1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context
                          .read<NavigationService>()
                          .navigateToInvoiceScreen(InvoiceScreen.list);
                    },
                  ),
                  const Gap(8),
                  AppText(
                    'Invoice #${invoice.invoiceNumber}',
                    size: 24,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatusBadge(),
                  const Gap(16),
                  if (invoice.status.toLowerCase() == 'unpaid')
                    FilledButton(
                      onPressed: () => _handleMarkAsPaid(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE04403),
                      ),
                      child: const Text(
                        'Mark as Paid',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  const Gap(16),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Download invoice functionality
                    },
                    child: const Text('Download Invoice'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Invoice Content
        Expanded(
          child: SingleChildScrollView(
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
                  // Company Logo and Invoice Details
                  Padding(
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
                  ),

                  // From and To Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // From Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'From:',
                                style: TextStyle(
                                  color: Color(0xFFE04403),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                'Bee Daisy Hair & Merchandise',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Text('+234 905 691 8846'),
                              const Text('12b Emma Abimbola Cole'),
                              const Text('Street, Lekki phase1'),
                              const Text('beedaisyhair@gmail.com'),
                            ],
                          ),
                        ),
                        // To Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'To:',
                                style: TextStyle(
                                  color: Color(0xFFE04403),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                '${invoice.client.firstName} ${invoice.client.lastName}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(invoice.client.phoneNumber),
                              Text(invoice.client.address),
                              Text(invoice.client.email),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(48),

                  // Products Table
                  Padding(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final color = invoice.status.toLowerCase() == 'paid'
        ? const Color(0xFF12B76A)
        : const Color(0xFFFDB022);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        invoice.status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

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

  Future<void> _handleMarkAsPaid(BuildContext context) async {
    // TODO: Implement mark as paid functionality
  }
}
