import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/client.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/invoice/invoice_form.dart';
import '../../widgets/invoice/preview_card.dart';
import '../../services/navigation_service.dart';
import '../../providers/invoice_provider.dart';
import '../../widgets/dialogs/success_dialog.dart';
import '../../widgets/common/loading_overlay.dart';

class CreateInvoiceContent extends StatefulWidget {
  const CreateInvoiceContent({super.key});

  @override
  State<CreateInvoiceContent> createState() => _CreateInvoiceContentState();
}

class _CreateInvoiceContentState extends State<CreateInvoiceContent> {

  BuildContext? _dialogContext;

  @override
  void initState() {
    super.initState();
    _dialogContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: Column(
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
                        const AppText(
                          'New Invoice',
                          size: 24,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // TODO: Save as draft functionality
                          },
                          child: const Text('Save as Draft'),
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: () => _showSendConfirmation(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE04403),
                          ),
                          child: const Text(
                            'Send Invoice',
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

              // Form and Preview side by side
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Invoice Form Section
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFC6C1C1)),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(24.0),
                                child: AppText(
                                  'Invoice Details',
                                  size: 18,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Divider(height: 1),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(24.0),
                                  child: InvoiceForm(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(24),
                      // Preview Section
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFC6C1C1)),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(24.0),
                                child: AppText(
                                  'Preview',
                                  size: 18,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Divider(height: 1),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(24.0),
                                  child: PreviewCard(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSendConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Send'),
        content: const Text(
          'Are you sure you want to send the invoice to John Doe?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSendInvoice(context);
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendInvoice(BuildContext context) async {
    final invoiceProvider = context.read<InvoiceProvider>();
    final navigationService = context.read<NavigationService>();
    
    final success = await invoiceProvider.sendInvoice(
      Invoice(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        companyId: '1',
        clientId: '1',
        invoiceNumber: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        status: 'unpaid',
        totalAmount: 1500.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        items: [],
        client: Client(
          id: '1',
          companyId: '1',
          firstName: 'John',
          lastName: 'Snow',
          email: 'john@example.com',
          phoneNumber: '1234567890',
          address: '123 Street',
        ),
      ),
    );

    if (success) {
    // if (success && context.mounted) {
      // Show success dialog
      await showDialog(
        context: _dialogContext!,
        barrierDismissible: false,
        builder: (context) => const SuccessDialog(message: 'Invoice sent successfully',),
      );
      
      // if (context.mounted) {
        // Navigate back to invoice list
        navigationService.navigateToInvoiceScreen(InvoiceScreen.list);
      // }
    }
  }
}
