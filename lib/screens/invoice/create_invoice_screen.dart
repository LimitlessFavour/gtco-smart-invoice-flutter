import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/custom_scroll_view.dart';

import '../../widgets/invoice/invoice_form.dart';
import 'preview_invoice_screen.dart';

class CreateInvoiceScreen extends StatelessWidget {
  const CreateInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreviewInvoiceScreen(),
                ),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.visibility_outlined),
                Gap(4),
                Text('Preview'),
              ],
            ),
          ),
          const Gap(16),
        ],
      ),
      body: const CustomScrollWrapper(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: InvoiceForm(),
        ),
      ),
    );
  }
}
