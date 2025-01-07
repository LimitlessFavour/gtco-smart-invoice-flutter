import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/custom_scroll_view.dart';

import '../../widgets/common/app_text.dart';
import 'widgets/settings_back_button.dart';
import '../../widgets/common/app_switch.dart';
import '../../widgets/common/app_number_input.dart';

class ProductsUpdateSettings extends StatefulWidget {
  const ProductsUpdateSettings({super.key});

  @override
  State<ProductsUpdateSettings> createState() => _ProductsUpdateSettingsState();
}

class _ProductsUpdateSettingsState extends State<ProductsUpdateSettings> {
  bool _isTrackInventory = false;
  bool _isStockNotification = false;
  bool _isDefaultQuantity = false;
  bool _isAutoFillProducts = false;
  int _notificationThreshold = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      width: double.maxFinite,
      color: Colors.white,
      child: CustomScrollWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(24),
            const SettingsBackButton(),
            const Gap(24),
            const AppText(
              'Product Update',
              size: 24,
              weight: FontWeight.w600,
            ),
            const Gap(32),
            const AppText(
              'Keep track of products while having seamless transcations',
              size: 16,
              weight: FontWeight.w500,
              color: Color(0xFF464646),
            ),
            const Gap(50),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.55,
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
                  const Gap(48),
                  _buildSettingItem(
                    'Stock Notification',
                    'Send an email when the stock reaches the threshold',
                    value: _isStockNotification,
                    onChanged: (value) =>
                        setState(() => _isStockNotification = value),
                  ),
                  const Gap(48),
                  _buildSettingWithNumberInput(
                    'Notification Threshold',
                    _notificationThreshold,
                    onChanged: (value) =>
                        setState(() => _notificationThreshold = value),
                  ),
                  const Gap(48),
                  _buildSettingItem(
                    'Default Quantity',
                    'Automatically set default quantity for products to one',
                    value: _isDefaultQuantity,
                    onChanged: (value) =>
                        setState(() => _isDefaultQuantity = value),
                  ),
                  const Gap(48),
                  _buildSettingItem(
                    'Auto-Fill products',
                    'Selecting a product will automatically fill in the cost',
                    value: _isAutoFillProducts,
                    onChanged: (value) =>
                        setState(() => _isAutoFillProducts = value),
                  ),
                  const Gap(48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String description, {
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                size: 20,
                weight: FontWeight.w600,
              ),
              const Gap(12),
              AppText(
                description,
                size: 16,
                weight: FontWeight.w500,
                color: const Color(0xFF464646),
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

  Widget _buildSettingWithNumberInput(
    String label,
    int value, {
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            label,
            size: 20,
            weight: FontWeight.w600,
          ),
        ),
        AppNumberInput(
          value: value,
          onChanged: onChanged,
          min: 1,
        ),
      ],
    );
  }
}
