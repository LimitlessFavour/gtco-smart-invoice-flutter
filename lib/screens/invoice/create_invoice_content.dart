import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/invoice/invoice_form.dart';
import '../../widgets/invoice/preview_card.dart';

class CreateInvoiceContent extends StatelessWidget {
  const CreateInvoiceContent({super.key});

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
              const AppText(
                'New Invoice',
                size: 24,
                weight: FontWeight.w600,
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
                    onPressed: () {
                      // TODO: Send invoice functionality
                    },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: AppText(
                            'Invoice Details',
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24.0),
                            child: const InvoiceForm(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: AppText(
                            'Preview',
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24.0),
                            child: const PreviewCard(),
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
    );
  }
}
