import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/invoice_list_content.dart';
import '../common/app_text.dart';

class InvoiceEmptyState extends StatelessWidget {
  const InvoiceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_invoice.png',
            height: 160,
            width: 120,
            // width: 200,
          ),
          const Spacer(),
          const AppText(
            'Create your first invoice!',
            size: 24,
            weight: FontWeight.w600,
          ),
          const Spacer(),
          const Center(
            child: SizedBox(
              width: 200,
              child: CreateInvoiceButton(),
            ),
          ),
        ],
      ),
    );
  }
}
