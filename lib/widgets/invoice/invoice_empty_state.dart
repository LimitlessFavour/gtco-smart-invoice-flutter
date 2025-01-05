import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../common/app_text.dart';

class InvoiceEmptyState extends StatelessWidget {
  const InvoiceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE84C3D),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: AppText(
                  'INVOICE ID',
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
              Expanded(
                flex: 3,
                child: AppText(
                  'CUSTOMER',
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
              Expanded(
                flex: 2,
                child: AppText(
                  'DATE',
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
              Expanded(
                flex: 2,
                child: AppText(
                  'TOTAL',
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
              Expanded(
                flex: 2,
                child: AppText(
                  'STATUS',
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Image.asset(
          'assets/images/empty_invoice.png',
          width: 200,
        ),
        const Gap(24),
        const AppText(
          'Create your first invoice!',
          size: 24,
          weight: FontWeight.w600,
        ),
        const Gap(16),
        ElevatedButton.icon(
          onPressed: () {
            // Handle create invoice
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const AppText(
            'Create invoice',
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE84C3D),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
} 