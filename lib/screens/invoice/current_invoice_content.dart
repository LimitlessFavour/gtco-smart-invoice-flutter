import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice_item.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/services/pdf_generator_service.dart';
import 'package:gtco_smart_invoice_flutter/widgets/dialogs/confirmation_dialog.dart';
import 'package:gtco_smart_invoice_flutter/widgets/invoice/invoice_back_button.dart';
import 'package:provider/provider.dart';

import '../../services/logger_service.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/dialogs/success_dialog.dart';
import '../../widgets/invoice/invoice_content_view.dart';

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
          decoration: const BoxDecoration(),
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
                          if (widget.invoice.status.toLowerCase() == 'unpaid' ||
                              widget.invoice.status.toLowerCase() ==
                                  'overdue') {
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
                          } else if (widget.invoice.status.toLowerCase() ==
                              'draft') {
                            return TextButton(
                              onPressed: () {
                                _handleFinalizeAndSendDraft(context);
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
          child: InvoiceContentView(invoice: widget.invoice),
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

  Future<void> _handleMarkAsPaid(BuildContext context) async {
    final provider = context.read<InvoiceProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Mark as Paid',
        content: 'Are you sure you want to mark invoice ${widget.invoice.id} as paid?',
        confirmText: 'Mark',
        cancelText: 'Cancel',
      ),
    );

    if(confirmed != true) return;

    try {
      final invoice = await provider.markAsPaid(widget.invoice);

      if (invoice != null) {
        await showDialog(
          context: context,
          builder: (_) => const AppSuccessDialog(
            title: 'Successful!',
            message: 'Invoice marked as paid!',
          ),
        );
        // TODO: update the invoice in in the invoice lists 
        //TODO: and make  sure this new status shows in this screen
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleFinalizeAndSendDraft(BuildContext context) async {
    // TODO: Implement handle and finalzie draft
  }

  Future<void> _handleDownloadInvoice(Invoice invoice) async {
    final provider = context.read<InvoiceProvider>();
    try {
      LoggerService.info('Starting invoice download',
          {'invoiceNumber': invoice.invoiceNumber});
      
      provider.setLoadingState(true);

      final pdfPath = await PdfGeneratorService.generateAndSavePdf(
        context.read<AuthProvider>().user!,
        invoice,
      );

      provider.setLoadingState(false);

      if (context.mounted) {
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
      provider.setLoadingState(false);
      LoggerService.error('Failed to generate PDF', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }
}
