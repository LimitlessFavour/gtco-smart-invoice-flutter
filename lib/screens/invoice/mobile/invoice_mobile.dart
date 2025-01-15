import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../providers/invoice_provider.dart';
import '../../../services/navigation_service.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/loading_overlay.dart';
import '../../../widgets/invoice/invoice_empty_state.dart';
import '../../../widgets/invoice/invoice_tile.dart';
import '../../../widgets/invoice/invoice_stats_card.dart';
import '../../../constants/styles.dart';
import 'create_invoice_mobile.dart';

class InvoiceMobile extends StatelessWidget {
  const InvoiceMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: LoadingOverlay(
            isLoading: provider.isLoading,
            child: Column(
              children: [
                // Stats Cards Grid
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: const [
                      InvoiceStatsCard(
                        icon: 'assets/icons/clock.svg',
                        amount: '₦0',
                        label: 'Overdue amount',
                        isMobile: true,
                      ),
                      InvoiceStatsCard(
                        icon: 'assets/icons/draft.svg',
                        amount: '₦0',
                        label: 'Drafted total',
                        isMobile: true,
                      ),
                      InvoiceStatsCard(
                        icon: 'assets/icons/update.svg',
                        amount: '₦0',
                        label: 'Updated total',
                        isMobile: true,
                      ),
                      InvoiceStatsCard(
                        icon: 'assets/icons/timer.svg',
                        amount: '0 day',
                        label: 'Average paid time',
                        isMobile: true,
                      ),
                    ],
                  ),
                ),
                // Search and Filter Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Search Field
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search invoices...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const Gap(16),
                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All invoices', true),
                            const Gap(8),
                            _buildFilterChip('Unpaid', false),
                            const Gap(8),
                            _buildFilterChip('Draft', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // Invoice List
                Expanded(
                  child: provider.hasInvoices
                      ? ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.invoices.length,
                          separatorBuilder: (context, index) => const Gap(16),
                          itemBuilder: (context, index) {
                            final invoice = provider.invoices[index];
                            return InvoiceTile(
                              invoice: invoice,
                              isMobile: true,
                            );
                          },
                        )
                      : const Center(child: InvoiceEmptyState(isMobile: true)),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateInvoiceMobile(),
                ),
              );
            },
            backgroundColor: const Color(0xFFE04403),
            label: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Gap(4),
                AppText(
                  'Create invoice',
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Handle filter selection
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.transparent : const Color(0xFFE0E0E0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
