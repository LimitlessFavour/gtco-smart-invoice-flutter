import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../common/app_text.dart';
import '../auth/custom_text_field.dart';

class InvoiceForm extends StatefulWidget {
  const InvoiceForm({super.key});

  @override
  State<InvoiceForm> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumberController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Customer Information',
            size: 18,
            weight: FontWeight.w600,
          ),
          const Gap(16),
          CustomTextField(
            label: 'Customer Name',
            hint: 'Enter customer name',
            controller: _customerNameController,
          ),
          const Gap(16),
          CustomTextField(
            label: 'Customer Email',
            hint: 'Enter customer email',
            controller: _customerEmailController,
          ),
          const Gap(16),
          CustomTextField(
            label: 'Customer Phone',
            hint: 'Enter customer phone',
            controller: _customerPhoneController,
          ),
          const Gap(24),
          const AppText(
            'Invoice Details',
            size: 18,
            weight: FontWeight.w600,
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Invoice Number',
                  hint: '#INV-001',
                  controller: _invoiceNumberController,
                ),
              ),
              const Gap(16),
              Expanded(
                child: _buildDatePicker(),
              ),
            ],
          ),
          const Gap(24),
          _buildItemsList(),
          const Gap(24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle form submission
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE84C3D),
                minimumSize: const Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Create Invoice'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Due Date',
          weight: FontWeight.w500,
        ),
        const Gap(8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() => _dueDate = date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const Gap(8),
                Text(
                  _dueDate == null
                      ? 'Select date'
                      : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                  style: TextStyle(
                    color: _dueDate == null ? Colors.grey[600] : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              'Items',
              size: 18,
              weight: FontWeight.w600,
            ),
            TextButton.icon(
              onPressed: () {
                // Add new item
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ],
        ),
        const Gap(16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Item Name',
                  hint: 'Enter item name',
                  controller: _itemNameController,
                ),
                const Gap(16),
                CustomTextField(
                  label: 'Description',
                  hint: 'Enter item description',
                  controller: _itemDescriptionController,
                  maxLines: 3,
                ),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Quantity',
                        hint: 'Enter quantity',
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Price',
                        hint: 'Enter price',
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        prefixText: '₦ ',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
