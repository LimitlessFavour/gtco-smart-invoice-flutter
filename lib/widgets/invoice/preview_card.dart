import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:provider/provider.dart';
import '../common/app_text.dart';
import '../common/company_logo.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    //get current user from auth rpovider:
    final user = context.read<AuthProvider>().user;
    final company = user?.company;

    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
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
                    const CompanyLogo(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText.heading('INVOICE', size: 24),
                        AppText(
                          '#${provider.currentInvoiceNumber}',
                          color: Colors.grey[600],
                        ),
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
                      company?.name ?? 'Your Company Name',
                      '${user?.email ?? 'your.email@example.com'}\n'
                          '${user?.phoneNumber ?? '+234 905 691 8846'}',
                    ),
                    _buildInfoSection(
                      'Bill To',
                      provider.selectedClient?.fullName ?? 'Customer Name',
                      '${provider.selectedClient?.email ?? 'customer@example.com'}\n'
                          '${provider.selectedClient?.phoneNumber ?? '+234 XXX XXX XXXX'}\n'
                          '${provider.selectedClient?.address ?? 'Address'}',
                    ),
                  ],
                ),
                const Gap(32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateInfo(
                      'Invoice Date',
                      DateTime.now().toString().split(' ')[0],
                    ),
                    _buildDateInfo(
                      'Due Date',
                      provider.dueDate?.toString().split(' ')[0] ?? ' -- ',
                    ),
                  ],
                ),
                const Gap(32),
                const Divider(),
                const Gap(16),
                _buildItemsTable(provider),
                const Gap(32),
                const Divider(),
                const Gap(16),
                _buildTotalSection(provider),
              ],
            ),
          ),
        );
      },
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

  Widget _buildItemsTable(InvoiceProvider provider) {
    return Column(
      children: [
        _buildTableHeader(),
        const Gap(16),
        ...provider.items.map((item) => Column(
              children: [
                _buildTableRow(
                  item.productName ?? 'Product',
                  item.quantity,
                  item.price,
                ),
                const Gap(8),
              ],
            )),
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

  Widget _buildTotalSection(InvoiceProvider provider) {
    return Column(
      children: [
        _buildTotalRow('Subtotal', '₦${provider.subtotal.toStringAsFixed(2)}'),
        const Gap(8),
        _buildTotalRow(
          'VAT (${provider.selectedVat.display})',
          '₦${provider.vatAmount.toStringAsFixed(2)}',
        ),
        const Gap(8),
        _buildTotalRow(
          'Total',
          '₦${provider.total.toStringAsFixed(2)}',
          isTotal: true,
        ),
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
