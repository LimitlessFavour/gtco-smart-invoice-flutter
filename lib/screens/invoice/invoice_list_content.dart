import 'package:flutter/material.dart';
import '../../widgets/invoice/invoice_stats_card.dart';
import '../../widgets/invoice/invoice_empty_state.dart';
import '../../widgets/invoice/invoice_form.dart';

class InvoiceListContent extends StatelessWidget {
  const InvoiceListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InvoiceStatsCard(
                            icon: 'assets/icons/clock.svg',
                            amount: '₦30,000',
                            label: 'Overdue amount',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InvoiceStatsCard(
                            icon: 'assets/icons/draft.svg',
                            amount: '₦60,400',
                            label: 'Drafted Total',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InvoiceStatsCard(
                            icon: 'assets/icons/update.svg',
                            amount: '₦800,000',
                            label: 'Updated Total',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InvoiceStatsCard(
                            icon: 'assets/icons/timer.svg',
                            amount: '8 days',
                            label: 'Average paid time',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter invoice number',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {},
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: constraints.maxHeight - 300, // Adjust this value based on your content
                      child: const InvoiceEmptyState(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.extended(
                onPressed: () => _showCreateInvoice(context),
                label: const Text('Create an invoice'),
                icon: const Icon(Icons.add),
                backgroundColor: const Color(0xFFE84C3D),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateInvoice(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 800,
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Invoice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const Expanded(
                child: InvoiceForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
