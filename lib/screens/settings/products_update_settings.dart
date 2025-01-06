import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/app_text.dart';
import '../../services/navigation_service.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<NavigationService>().navigateToSettingsScreen(
                    SettingsScreen.list,
                  );
                },
              ),
              const Gap(8),
              const AppText(
                'Products Update',
                size: 24,
                weight: FontWeight.w600,
              ),
            ],
          ),
          const Gap(8),
          AppText(
            'Keep track of products while having seamless transcations',
            size: 14,
            color: Colors.grey[600],
          ),
          const Gap(32),
          Container(
            width: 0.55 * MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC6C1C6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingItem(
                  'Track Inventory',
                  'Display a product stock field and update when invoices are sent',
                  value: _isTrackInventory,
                  onChanged: (value) => setState(() => _isTrackInventory = value),
                ),
                const Gap(16),
                _buildSettingItem(
                  'Stock Notification',
                  'Send an email when the stock reaches the threshold',
                  value: _isStockNotification,
                  onChanged: (value) => setState(() => _isStockNotification = value),
                ),
                const Gap(16),
                _buildNumberInput(
                  'Notification Threshold',
                  _notificationThreshold,
                  onChanged: (value) => setState(() => _notificationThreshold = value),
                ),
                const Gap(16),
                _buildSettingItem(
                  'Default Quantity',
                  'Automatically set default quantity for products to one',
                  value: _isDefaultQuantity,
                  onChanged: (value) => setState(() => _isDefaultQuantity = value),
                ),
                const Gap(16),
                _buildSettingItem(
                  'Auto-Fill products',
                  'Selecting a product will automatically fill in the cost',
                  value: _isAutoFillProducts,
                  onChanged: (value) => setState(() => _isAutoFillProducts = value),
                ),
              ],
            ),
          ),
        ],
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
                size: 16,
                weight: FontWeight.w600,
              ),
              AppText(
                description,
                size: 14,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildNumberInput(
    String label,
    int value, {
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        AppText(
          label,
          size: 16,
          weight: FontWeight.w600,
        ),
        const Spacer(),
        Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: value.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => onChanged(int.tryParse(value) ?? 1),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => onChanged(value + 1),
                    child: const Icon(Icons.arrow_drop_up, size: 18),
                  ),
                  InkWell(
                    onTap: () => onChanged(value > 1 ? value - 1 : 1),
                    child: const Icon(Icons.arrow_drop_down, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
} 