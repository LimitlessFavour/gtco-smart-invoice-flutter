import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/invoice/invoice_stats_card.dart';
import '../../widgets/invoice/invoice_empty_state.dart';
import 'create_invoice_screen.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
          const Gap(8),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
          ),
          const Gap(16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: InvoiceStatsCard(
                    icon: 'assets/icons/clock.svg',
                    amount: '₦30,000',
                    label: 'Overdue amount',
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: InvoiceStatsCard(
                    icon: 'assets/icons/draft.svg',
                    amount: '₦60,400',
                    label: 'Drafted Total',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: InvoiceStatsCard(
                    icon: 'assets/icons/update.svg',
                    amount: '₦800,000',
                    label: 'Updated Total',
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: InvoiceStatsCard(
                    icon: 'assets/icons/timer.svg',
                    amount: '8 days',
                    label: 'Average paid time',
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter invoice number',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Handle filter
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const Expanded(
            child: InvoiceEmptyState(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateInvoiceScreen(),
            ),
          );
        },
        label: const Text('Create an invoice'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFFE84C3D),
      ),
    );
  }
}
