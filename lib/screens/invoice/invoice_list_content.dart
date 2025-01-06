import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import 'package:gtco_smart_invoice_flutter/widgets/invoice/invoices_sent_out_today.dart';
import 'package:provider/provider.dart';

import '../../services/navigation_service.dart';
import '../../widgets/invoice/invoice_empty_state.dart';
import '../../widgets/invoice/invoice_stats_card.dart';

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
              const SizedBox(
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
              ),
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
                  child: const Column(
                    children: [
                      // Search and Filter Row
                      SearchAndFilterRow(),
                      Gap(24),
                      // Table Header
                      TableHeader(),
                      Gap(24),
                      // Empty State
                      Expanded(child: InvoiceEmptyState()),
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Field
        SizedBox(
          width: 252, // Fixed width as per design
          child: Container(
            height: 32, // Height as per design
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter invoice number',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 20,
                ),
                border: InputBorder.none,
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
          height: 32, // Match search bar height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_list, size: 20, color: Colors.grey[800]),
              const Gap(8),
              Text(
                'Filter',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Gap(24),

        // Sort Dropdown
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Newest First',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(8),
              Icon(Icons.keyboard_arrow_down,
                  size: 20, color: Colors.grey[800]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTab(String label) {
    final bool isSelected = selectedFilter == label;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F5F5) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
