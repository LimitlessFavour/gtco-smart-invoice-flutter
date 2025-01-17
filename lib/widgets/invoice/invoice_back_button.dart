import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import 'package:provider/provider.dart';

class InvoiceBackButton extends StatelessWidget {
  const InvoiceBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<NavigationService>()
            .navigateToInvoiceScreen(InvoiceScreen.list);
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, size: 16),
          Gap(1.5),
          AppText(
            'Invoices',
            size: 16,
            weight: FontWeight.w500,
          ),
          Gap(30),
        ],
      ),
    );
  }
}
