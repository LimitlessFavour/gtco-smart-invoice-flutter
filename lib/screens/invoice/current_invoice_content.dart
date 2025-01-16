import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice_item.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:gtco_smart_invoice_flutter/services/pdf_generator_service.dart';
import 'package:gtco_smart_invoice_flutter/widgets/invoice/invoice_back_button.dart';
import 'package:provider/provider.dart';

import '../../services/logger_service.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/dialogs/success_dialog.dart';

class CurrentInvoiceContent extends StatefulWidget {
  final Invoice invoice;

  const CurrentInvoiceContent({
    super.key,
    required this.invoice,
  });

  @override
  State<CurrentInvoiceContent> createState() => _CurrentInvoiceContentState();
}

class _CurrentInvoiceContentState extends State<CurrentInvoiceContent> {
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
              // color: Color(0xFFF2F2F2),
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(16),
              //   topRight: Radius.circular(16),
              // ),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InvoiceBackButton(),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        'Invoice #${widget.invoice.invoiceNumber}',
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                      const Gap(16),
                      _buildStatusBadge(),
                    ],
                  ),
                  Row(
                    children: [
                      const Gap(16),
                      Builder(
                        builder: (context) {
                          if (widget.invoice.status.toLowerCase() == 'unpaid') {
                            return TextButton(
                              onPressed: () {
                                _handleMarkAsPaid(context);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFFF9D9D2),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const AppText(
                                'Mark as Paid',
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      const Gap(16),
                      ElevatedButton(
                        onPressed: () {
                          _handleDownloadInvoice(widget.invoice);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE04826),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const AppText(
                          'Download Invoice',
                          size: 16,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
                              'Date: ${_formatDate(widget.invoice.createdAt)}',
                              style: const TextStyle(color: Color(0xFF667085)),
                            ),
                            const Gap(4),
                            Text(
                              'Due Date: ${_formatDate(widget.invoice.dueDate)}',
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
                                '${widget.invoice.client.firstName} ${widget.invoice.client.lastName}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(widget.invoice.client.phoneNumber),
                              Text(widget.invoice.client.address),
                              Text(widget.invoice.client.email),
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
                        ...widget.invoice.items.map(_buildTableRow),
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
    Color backgroundColor = Colors.white;
    Color textColor = Colors.white;
    final status = widget.invoice.status.toLowerCase();

    print('the status: $status');

    switch (status.toLowerCase()) {
      case 'paid':
        backgroundColor = const Color(0xFFECFDF3);
        textColor = const Color(0xFF027A48);
        break;
      case 'unpaid':
        backgroundColor = const Color(0xffFCB300).withOpacity(0.1);
        textColor = const Color(0xffFCB300);
        break;
      case 'overdue':
        backgroundColor = const Color(0xFFFEF3F2);
        textColor = const Color(0xFFB42318);
        break;
      case 'drafted':
        backgroundColor = const Color(0xFFF2F4F7);
        textColor = const Color(0xFF344054);
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(
        widget.invoice.status,
        color: textColor,
        weight: FontWeight.w500,
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
          '₦${widget.invoice.totalAmount.toStringAsFixed(2)}',
        ),
        _buildTotalRow('Discount', '-'),
        _buildTotalRow('VAT', '-'),
        const Divider(),
        _buildTotalRow(
          'Total',
          '₦${widget.invoice.totalAmount.toStringAsFixed(2)}',
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

  // Example usage in a button press handler
  Future<void> _handleDownloadInvoice(Invoice invoice) async {
    // print('invocie');
    // print(invoice.items.map((items) => items.toJson()));
    // return;
    try {
      LoggerService.info('Starting invoice download',
          {'invoiceNumber': invoice.invoiceNumber});
      // LoadingOverlay.show(context); // Show loading indicator

      final pdfPath = await PdfGeneratorService.generateAndSavePdf(
        context.read<AuthProvider>().user!,
        invoice,
      );

      if (context.mounted) {
        // LoadingOverlay.hide(); // Hide loading indicator

        final shouldOpen = await showDialog<bool>(
          context: context,
          builder: (_) => const AppSuccessDialog(
            title: 'Download Successful!',
            message: 'Your invoice has been downloaded successfully.',
            buttonText: 'Open Now',
          ),
        );

        if (shouldOpen == true && context.mounted) {
          try {
            await PdfGeneratorService.openPdf(pdfPath);
          } catch (e) {
            LoggerService.error('Failed to open PDF', error: e);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to open PDF')),
              );
            }
          }
        }
      }
    } catch (e) {
      // LoadingOverlay.hide(); // Hide loading indicator on error
      LoggerService.error('Failed to generate PDF', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }
}
