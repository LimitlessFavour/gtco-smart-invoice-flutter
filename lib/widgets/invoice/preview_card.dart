import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtco_smart_invoice_flutter/models/auth/user.dart';
import 'package:gtco_smart_invoice_flutter/models/company.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/powered_by_gtco.dart';
import 'package:provider/provider.dart';
import '../common/app_text.dart';
import '../common/company_logo.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    final company = user?.company;

    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        final isMobile = MediaQuery.of(context).size.width < 600;

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
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
                        AutoSizeText(
                          'INVOICE',
                          style: GoogleFonts.urbanist(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          '#${provider.currentInvoiceNumber}',
                          style: GoogleFonts.urbanist(
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(32),
                isMobile
                    ? _buildMobileInfoSection(company, user, provider)
                    : _buildDesktopInfoSection(company, user, provider),
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
                _buildItemsTable(provider, isMobile),
                const Gap(32),
                const Divider(),
                const Gap(16),
                _buildTotalSection(provider),
                const Gap(32),
                const PoweredByGtco(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileInfoSection(Company? company, User? user, InvoiceProvider provider) {
    return Column(
      children: [
        _buildInfoSection(
          'From',
          company?.name ?? 'Your Company Name',
          '${user?.email ?? 'your.email@example.com'}\n'
              '${user?.phoneNumber ?? '+234 905 691 8846'}',
        ),
        const Gap(16),
        _buildInfoSection(
          'Bill To',
          provider.selectedClient?.fullName ?? 'Customer Name',
          '${provider.selectedClient?.email ?? 'customer@example.com'}\n'
              '${provider.selectedClient?.phoneNumber ?? '+234 XXX XXX XXXX'}\n'
              '${provider.selectedClient?.address ?? 'Address'}',
        ),
      ],
    );
  }

  Widget _buildDesktopInfoSection(Company? company, User? user, InvoiceProvider provider) {
    return Row(
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
    );
  }

  Widget _buildInfoSection(String title, String name, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          title,
          style: GoogleFonts.urbanist(color: Colors.grey[600]),
          maxLines: 1,
        ),
        const Gap(8),
        AutoSizeText(
          name,
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
          maxLines: 2,
        ),
        const Gap(4),
        AutoSizeText(
          details,
          style: GoogleFonts.urbanist(fontSize: 14),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDateInfo(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          label,
          style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
          maxLines: 1,
        ),
        const Gap(4),
        AutoSizeText(
          date,
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w500),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildItemsTable(InvoiceProvider provider, bool isMobile) {
    return Column(
      children: [
        _buildTableHeader(isMobile),
        const Gap(16),
        ...provider.items.map((item) => Column(
              children: [
                _buildTableRow(
                  item.productName ?? 'Product',
                  item.quantity,
                  item.price,
                  isMobile,
                ),
                const Gap(8),
              ],
            )),
      ],
    );
  }

  Widget _buildTableHeader(bool isMobile) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AutoSizeText(
            'Item',
            style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
            maxLines: 1,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            'Qty',
            style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
            maxLines: 1,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            'Price',
            style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
            maxLines: 1,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            'Total',
            style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(String item, int qty, double price, bool isMobile) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AutoSizeText(
            item,
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w500),
            maxLines: 2,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            qty.toString(),
            maxLines: 1,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            '₦${price.toStringAsFixed(2)}',
            maxLines: 1,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            '₦${(qty * price).toStringAsFixed(2)}',
            maxLines: 1,
          ),
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
        AutoSizeText(
          label,
          style: GoogleFonts.urbanist(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
          maxLines: 1,
        ),
        AutoSizeText(
          amount,
          style: GoogleFonts.urbanist(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}