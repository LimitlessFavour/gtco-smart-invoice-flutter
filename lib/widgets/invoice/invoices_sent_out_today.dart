import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';

class InvoicesSentOutToday extends StatelessWidget {
  const InvoicesSentOutToday({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 34, top: 24, bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/invoice_sent_out.png',
            height: 80,
            width: 80,
          ),
          const Gap(12),
          Consumer<InvoiceProvider>(
            builder: (context, provider, _) {
              final sentToday = provider.stats?.totalInvoicesSentToday ?? 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    '$sentToday ${sentToday == 1 ? 'invoice' : 'invoices'}',
                    color: Colors.black,
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                  const Gap(3),
                  const AppText(
                    'Sent out today',
                    color: Color(0xFF464646),
                    weight: FontWeight.w600,
                    size: 12,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
