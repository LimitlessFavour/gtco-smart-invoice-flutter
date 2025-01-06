import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                '0 invoice',
                color: Colors.black,
                weight: FontWeight.w600,
                size: 16,
              ),
              Gap(3),
              AppText(
                'Sent out today',
                color: Color(0xFF464646),
                weight: FontWeight.w600,
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
