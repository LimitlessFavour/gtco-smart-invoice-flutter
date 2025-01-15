import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/client.dart';
import 'package:gtco_smart_invoice_flutter/models/invoice_item.dart';
import 'package:gtco_smart_invoice_flutter/models/product.dart';
import 'package:gtco_smart_invoice_flutter/models/product_enums.dart';
import 'package:gtco_smart_invoice_flutter/providers/invoice_provider.dart';
import 'package:gtco_smart_invoice_flutter/widgets/dialogs/client_selection_dialog.dart';
import 'package:gtco_smart_invoice_flutter/widgets/dialogs/product_selection_dialog.dart';
import 'package:provider/provider.dart';
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
  final _customerAddressController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _dueDate;
  late final InvoiceProvider _invoiceProvider;

  @override
  void initState() {
    super.initState();
    _invoiceProvider = context.read<InvoiceProvider>();
    // Add listener for client changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invoiceProvider.addListener(_updateClientFields);
    });
  }

  @override
  void dispose() {
    _invoiceProvider.removeListener(_updateClientFields);
    _invoiceNumberController.dispose();
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateClientFields() {
    final client = _invoiceProvider.selectedClient;
    if (client != null) {
      _customerPhoneController.text = client.phoneNumber;
      _customerEmailController.text = client.email;
      _customerAddressController.text = client.address;
    } else {
      _customerPhoneController.clear();
      _customerEmailController.clear();
      _customerAddressController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Invoice Number',
                      hint: provider.currentInvoiceNumber,
                      controller: TextEditingController(
                          text: provider.currentInvoiceNumber),
                      readOnly: true,
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: _buildDatePicker(),
                  ),
                ],
              ),
              const Gap(16),
              CustomTextField(
                label: 'Bill To',
                hint: provider.selectedClient?.fullName ?? 'Enter client',
                controller: TextEditingController(
                  text: provider.selectedClient?.fullName ?? '',
                ),
                readOnly: true,
                suffix: IconButton(
                  icon: const Icon(Icons.person_search),
                  onPressed: () async {
                    final client = await showDialog<Client>(
                      context: context,
                      builder: (_) => const ClientSelectionDialog(),
                    );
                    if (client != null) {
                      provider.setSelectedClient(client);
                    }
                  },
                ),
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Phone Number',
                      hint: 'Enter customer phone',
                      controller: _customerPhoneController,
                      readOnly: true,
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Email',
                      hint: 'Enter customer email',
                      controller: _customerEmailController,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              CustomTextField(
                label: 'Address',
                hint: 'Enter address',
                controller: _customerAddressController,
                readOnly: true,
              ),
              const Gap(24),
              // VAT Selection
              DropdownButtonFormField<VatCategory>(
                value: provider.selectedVat,
                decoration: const InputDecoration(
                  labelText: 'VAT',
                ),
                items: VatCategory.values.map((vat) {
                  return DropdownMenuItem(
                    value: vat,
                    child: Text(vat.display),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    provider.setVatCategory(value);
                  }
                },
              ),
              const Gap(24),
              _buildItemsList(),
              const Gap(24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDatePicker() {
    final provider = context.watch<InvoiceProvider>();
    final dueDate = provider.dueDate;

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
              provider.setDueDate(date);
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
                  dueDate == null
                      ? 'Select date'
                      : '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                  style: TextStyle(
                    color: dueDate == null ? Colors.grey[600] : Colors.black,
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
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  'Invoice items',
                  size: 24,
                  weight: FontWeight.w600,
                ),
                TextButton.icon(
                  onPressed: () async {
                    final product = await showDialog<Product>(
                      context: context,
                      builder: (_) => const ProductSelectionDialog(),
                    );
                    if (product != null) {
                      provider.addItem(product);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const AppText(
                    'Add Item',
                    size: 16,
                  ),
                ),
              ],
            ),
            const Gap(16),
            if (provider.items.isEmpty)
              const Center(
                child: AppText(
                  'No items added yet',
                  color: Colors.grey,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = provider.items[index];
                  return ListTile(
                    title: AppText(item.productName ?? 'Product'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          item.description ?? 'Description',
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        Row(
                          children: [
                            AppText(
                              '₦${item.price}',
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                            const Gap(8),
                            AppText(
                              'x ${item.quantity}',
                              size: 14,
                            ),
                            const Gap(8),
                            AppText(
                              '= ₦${item.total}',
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Show quantity editor
                            _showQuantityEditor(context, item);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            provider.removeItem(item.productId.toString());
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  void _showQuantityEditor(BuildContext context, InvoiceItem item) {
    final controller = TextEditingController(text: item.quantity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Quantity'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final quantity = int.tryParse(controller.text);
              if (quantity != null && quantity > 0) {
                context.read<InvoiceProvider>().updateItemQuantity(
                      item.productId.toString(),
                      quantity,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
