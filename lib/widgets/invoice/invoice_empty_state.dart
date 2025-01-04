import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InvoiceEmptyState extends StatelessWidget {
  const InvoiceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_invoice.png',
            width: 200,
          ),
          const Gap(24),
          const Text(
            'You do not have any invoicce created yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
} 