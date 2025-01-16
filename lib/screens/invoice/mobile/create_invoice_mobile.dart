import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/mobile/preview_invoice_screen.dart';
import 'package:provider/provider.dart';

import '../../../providers/invoice_provider.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/loading_overlay.dart';

class CreateInvoiceMobile extends StatefulWidget {
  const CreateInvoiceMobile({super.key});

  @override
  State<CreateInvoiceMobile> createState() => _CreateInvoiceMobileState();
}

class _CreateInvoiceMobileState extends State<CreateInvoiceMobile> {
  BuildContext? _dialogContext;

  @override
  void initState() {
    super.initState();
    _dialogContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const AppText(
              'Invoice Details',
              size: 20,
              weight: FontWeight.w600,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: LoadingOverlay(
            isLoading: provider.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice Number
                  _buildInputField(
                    'Invoice number',
                    '#1001',
                    readOnly: true,
                  ),
                  const Gap(16),

                  // Due Date
                  _buildInputField(
                    'Due date',
                    '20/10/2025',
                    suffix: const Icon(Icons.calendar_today_outlined),
                  ),
                  const Gap(16),

                  // Bill To
                  _buildInputField(
                    'Bill to',
                    'Enter customer\'s name',
                  ),
                  const Gap(16),

                  // Address
                  _buildInputField(
                    'Address',
                    'Enter address',
                    maxLines: 3,
                  ),
                  const Gap(24),

                  // Invoice Items Section
                  const AppText(
                    'Invoice items',
                    size: 20,
                    weight: FontWeight.w600,
                  ),
                  const Gap(16),

                  // Currency Dropdown
                  _buildInputField(
                    'Currency',
                    'Naira ₦',
                    suffix: const Icon(Icons.keyboard_arrow_down),
                  ),
                  const Gap(16),

                  // Product Input
                  _buildInputField(
                    'Product',
                    'Product Name',
                  ),
                  const Gap(16),

                  // Quantity, Rate, Total Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField('QTY', '0'),
                      ),
                      const Gap(16),
                      Expanded(
                        child: _buildInputField('Rate', '0'),
                      ),
                      const Gap(16),
                      Expanded(
                        child: _buildInputField('Total', '0', readOnly: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => _handleNext(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE04403),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const AppText(
                  'Next',
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(
    String label,
    String hint, {
    Widget? suffix,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          size: 16,
          color: const Color(0xFF464646),
        ),
        const Gap(8),
        TextField(
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
            suffixIcon: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE04403)),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNext(BuildContext context) {
    // TODO: Implement next step navigation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PreviewInvoiceScreen(),
      ),
    );
  }
}
