import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/loading_overlay.dart';
import 'package:gtco_smart_invoice_flutter/widgets/invoice/invoices_sent_out_today.dart';
import 'package:provider/provider.dart';

import '../../services/navigation_service.dart';
import '../../widgets/invoice/invoice_empty_state.dart';
import '../../widgets/invoice/invoice_stats_card.dart';
import '../../widgets/invoice/invoice_tile.dart';

class InvoiceListContent extends StatelessWidget {
  const InvoiceListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              const HeaderRow(),
              const Gap(24),
              // Stats Row
              const StatsRow(),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(top: 24),
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFC6C1C1)),
                  ),
                  child: Column(
                    children: [
                      // Search and Filter Row
                      const SearchAndFilterRow(),
                      const Gap(24),
                      // Table Header
                      const TableHeader(),
                      const Gap(24),
                      // Empty State
                      Expanded(
                        child: Consumer<InvoiceProvider>(
                          builder: (context, provider, child) {
                            return LoadingOverlay(
                              isLoading: provider.isLoading,
                              child: provider.hasInvoices
                                  ? ListView.separated(
                                      padding: const EdgeInsets.all(24),
                                      itemCount: provider.invoices.length,
                                      separatorBuilder: (context, index) =>
                                          const Gap(16),
                                      itemBuilder: (context, index) {
                                        final invoice =
                                            provider.invoices[index];
                                        return InvoiceTile(invoice: invoice);
                                      },
                                    )
                                  : const InvoiceEmptyState(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),
            ],
          ),
        );
      },
    );
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InvoiceStatsCard(
            icon: 'assets/icons/clock.svg',
            amount: '₦0',
            label: 'Overdue amount',
          ),
          // Gap(40),
          InvoiceStatsCard(
            icon: 'assets/icons/draft.svg',
            amount: '₦0',
            label: 'Drafted total',
          ),
          // Gap(40),
          InvoiceStatsCard(
            icon: 'assets/icons/update.svg',
            amount: '₦0',
            label: 'Updated total',
          ),
          // Gap(40),
          InvoiceStatsCard(
            icon: 'assets/icons/timer.svg',
            amount: '0 day',
            label: 'Average paid time',
          ),
          // Gap(40),
          InvoicesSentOutToday(),
        ],
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  const HeaderRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          'Invoices',
          size: 24,
          weight: FontWeight.w600,
        ),
        CreateInvoiceButton(),
      ],
    );
  }
}

class CreateInvoiceButton extends StatelessWidget {
  const CreateInvoiceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<NavigationService>()
            .navigateToInvoiceScreen(InvoiceScreen.create);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE04403),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              'Create invoice',
              color: Colors.white,
              weight: FontWeight.w500,
            ),
            Gap(4),
            Icon(Icons.add, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  const TableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE04403),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
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
    );
  }
}

class SearchAndFilterRow extends StatefulWidget {
  const SearchAndFilterRow({
    super.key,
  });

  @override
  State<SearchAndFilterRow> createState() => _SearchAndFilterRowState();
}

class _SearchAndFilterRowState extends State<SearchAndFilterRow> {
  String selectedFilter = 'All invoices';
  String selectedSort = 'Newest First';

  final List<String> sortOptions = [
    'Newest First',
    'Oldest First',
    'Highest Amount',
    'Lowest Amount',
  ];

  // Sample counter data (replace with actual data from your provider)
  final Map<String, int> filterCounts = {
    'All invoices': 30,
    'Unpaid': 30,
    'Draft': 2,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Field
        SizedBox(
          width: 252,
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter invoice number',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ),
        const Gap(24),

        // Filter Tabs
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterTab('All invoices'),
              _buildFilterTab('Unpaid'),
              _buildFilterTab('Draft'),
            ],
          ),
        ),
        const Spacer(),

        // Filter Button
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_list, size: 20, color: Colors.grey[800]),
              const Gap(8),
              AppText(
                'Filter',
                size: 14,
                weight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ],
          ),
        ),
        const Gap(24),

        // Sort Dropdown
        PopupMenuButton<String>(
          offset: const Offset(0, 40),
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  selectedSort,
                  size: 14,
                  weight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                const Gap(8),
                Icon(Icons.keyboard_arrow_down,
                    size: 20, color: Colors.grey[800]),
              ],
            ),
          ),
          itemBuilder: (context) => sortOptions
              .map(
                (option) => PopupMenuItem<String>(
                  value: option,
                  child: AppText(
                    option,
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
              )
              .toList(),
          onSelected: (value) {
            setState(() {
              selectedSort = value;
              // TODO: Implement sorting logic
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterTab(String label) {
    final bool isSelected = selectedFilter == label;
    final int count = filterCounts[label] ?? 0;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = label;
          // TODO: Implement filtering logic based on selected filter
        });
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F5F5) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              label,
              size: 14,
              weight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE04403) : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppText(
                count.toString(),
                size: 12,
                weight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
