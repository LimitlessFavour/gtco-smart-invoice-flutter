import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_switch.dart';
import '../../../widgets/common/app_number_input.dart';

class ProductsUpdateSettingsMobile extends StatefulWidget {
  const ProductsUpdateSettingsMobile({super.key});

  @override
  State<ProductsUpdateSettingsMobile> createState() =>
      _ProductsUpdateSettingsMobileState();
}

class _ProductsUpdateSettingsMobileState
    extends State<ProductsUpdateSettingsMobile> {
  bool _isTrackInventory = false;
  bool _isStockNotification = false;
  bool _isDefaultQuantity = false;
  bool _isAutoFillProducts = false;
  int _notificationThreshold = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Products Update',
          size: 18,
          weight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Keep track of products while having seamless transactions',
              size: 14,
              color: Colors.grey[600],
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    'Track Inventory',
                    'Display a product stock field and update when invoices are sent',
                    value: _isTrackInventory,
                    onChanged: (value) =>
                        setState(() => _isTrackInventory = value),
                  ),
                  const Gap(24),
                  _buildSettingItem(
                    'Stock Notification',
                    'Send an email when the stock reaches the threshold',
                    value: _isStockNotification,
                    onChanged: (value) =>
                        setState(() => _isStockNotification = value),
                  ),
                  if (_isStockNotification) ...[
                    const Gap(16),
                    AppNumberInput(
                      // label: 'Notification Threshold',
                      value: _notificationThreshold,
                      onChanged: (value) =>
                          setState(() => _notificationThreshold = value),
                    ),
                  ],
                  const Gap(24),
                  _buildSettingItem(
                    'Default Quantity',
                    'Set default quantity for new products',
                    value: _isDefaultQuantity,
                    onChanged: (value) =>
                        setState(() => _isDefaultQuantity = value),
                  ),
                  const Gap(24),
                  _buildSettingItem(
                    'Auto-fill Products',
                    'Automatically fill in product details from previous entries',
                    value: _isAutoFillProducts,
                    onChanged: (value) =>
                        setState(() => _isAutoFillProducts = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String description,
      {required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                size: 16,
                weight: FontWeight.w500,
              ),
              const Gap(4),
              AppText(
                description,
                size: 14,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
        AppSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
