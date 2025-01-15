import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';

class FilterCriteria {
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  double? minAmount;
  double? maxAmount;

  bool get isEmpty =>
      startDate == null &&
      endDate == null &&
      status == null &&
      minAmount == null &&
      maxAmount == null;
}

class InvoiceFilterDialog extends StatefulWidget {
  final FilterCriteria initialCriteria;
  final Function(FilterCriteria) onApply;

  const InvoiceFilterDialog({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  @override
  State<InvoiceFilterDialog> createState() => _InvoiceFilterDialogState();
}

class _InvoiceFilterDialogState extends State<InvoiceFilterDialog> {
  late FilterCriteria _criteria;
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _criteria = widget.initialCriteria;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Filter Invoices',
              size: 20,
              weight: FontWeight.w600,
            ),
            const Gap(24),

            // Date Range
            const AppText('Date Range', weight: FontWeight.w600),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    label: 'Start Date',
                    value: _criteria.startDate,
                    onChanged: (date) {
                      setState(() => _criteria.startDate = date);
                    },
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: _buildDatePicker(
                    label: 'End Date',
                    value: _criteria.endDate,
                    onChanged: (date) {
                      setState(() => _criteria.endDate = date);
                    },
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Status
            const AppText('Status', weight: FontWeight.w600),
            const Gap(8),
            DropdownButtonFormField<String>(
              value: _criteria.status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ['All', 'Paid', 'Unpaid', 'Draft']
                  .map((status) => DropdownMenuItem(
                        value: status == 'All' ? null : status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _criteria.status = value);
              },
            ),
            const Gap(16),

            // Amount Range
            const AppText('Amount Range', weight: FontWeight.w600),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Min Amount',
                      prefixText: '₦ ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _criteria.minAmount = double.tryParse(value);
                    },
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: TextField(
                    controller: _maxAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Max Amount',
                      prefixText: '₦ ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _criteria.maxAmount = double.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
            const Gap(24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const Gap(8),
                ElevatedButton(
                  onPressed: () {
                    widget.onApply(_criteria);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? value,
    required Function(DateTime?) onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          value == null ? label : '${value.day}/${value.month}/${value.year}',
        ),
      ),
    );
  }
}
