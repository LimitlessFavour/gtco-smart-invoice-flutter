import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/layouts/main_layout.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/mobile/invoice_mobile.dart';
import '../../../widgets/common/custom_scroll_view.dart';
import '../../../widgets/invoice/preview_card.dart';

class PreviewInvoiceScreen extends StatelessWidget {
  const PreviewInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Handle share
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              // Handle download
            },
          ),
          const Gap(16),
        ],
      ),
      body: CustomScrollWrapper(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PreviewCard(),
              const Gap(24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit Invoice'),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        //   showSendConfirmation(
                        //   context,
                        //   onSuccess: (context) {
                        //     Navigator.of(context).pushReplacement(
                        //       MaterialPageRoute(
                        //         builder: (context) => const MainLayout(),
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE04403),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Send Invoice',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
