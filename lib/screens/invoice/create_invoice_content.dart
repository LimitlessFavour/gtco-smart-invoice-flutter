import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../providers/invoice_provider.dart';
import '../../services/navigation_service.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/dialogs/success_dialog.dart';
import '../../widgets/invoice/invoice_form.dart';
import '../../widgets/invoice/preview_card.dart';

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

  Future<void> _handleCreateInvoice() async {
    final createProvider = context.read<InvoiceProvider>();

    if (!createProvider.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
        ),
      );
      return;
    }

    try {
      final invoice = await createProvider.createInvoice();

      if (invoice != null) {
        await showDialog(
          context: context,
          builder: (_) => const SuccessDialog(
            message: 'Invoice created successfully!',
          ),
        );
        createProvider.createClear();
        // TODO: Navigate to invoice list screen
        context
            .read<NavigationService>()
            .navigateToInvoiceScreen(InvoiceScreen.list);
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
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
                            'Save as Draft',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: () {
                            _handleCreateInvoice();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffE04826),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const AppText(
                            'Send Invoice',
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: () {
                            // showSendConfirmation(
                            //   context,
                            //   clientName: 'John Doe',
                            //   onSuccess: (context) {
                            //     context
                            //         .read<NavigationService>()
                            //         .navigateToInvoiceScreen(
                            //             InvoiceScreen.list);
                            //   },
                            // );
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
                                padding: EdgeInsets.only(top: 24.0, left: 24.0),
                                child: AppText(
                                  'Invoice Details',
                                  size: 24,
                                  weight: FontWeight.w600,
                                ),
                              ),
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
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFC6C1C1)),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 24.0, left: 24.0),
                                child: AppText(
                                  'Preview',
                                  size: 24,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    top: 24.0,
                                    left: 24.0,
                                    right: 24.0,
                                  ),
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
}
