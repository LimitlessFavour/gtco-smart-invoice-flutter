import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/invoice_list_content.dart';
import '../common/app_text.dart';

class InvoiceEmptyState extends StatelessWidget {
  final bool isMobile;

  const InvoiceEmptyState({
    super.key,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_invoice.png',
            height: isMobile ? 120 : 160,
            width: isMobile ? 90 : 120,
          ),
          Gap(isMobile ? 16 : 24),
          AppText(
            'Create your first invoice!',
            size: isMobile ? 20 : 24,
            weight: FontWeight.w600,
          ),
          Gap(isMobile ? 16 : 24),
          if (!isMobile)
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
