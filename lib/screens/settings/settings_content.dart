import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Settings',
            size: 24,
            weight: FontWeight.w600,
          ),
          const Gap(24),
          
          // Settings Options List
          Column(
            children: [
              _buildSettingItem(
                'Basic Information',
                'Add or edit basic information about your business',
                onTap: () {
                  // TODO: Navigate to basic information settings
                },
              ),
              const Gap(16),
              _buildSettingItem(
                'Brand Appearance',
                'Choose a logo and default theme for invoice sent to clients',
                onTap: () {
                  // TODO: Navigate to brand appearance settings
                },
              ),
              const Gap(16),
              _buildSettingItem(
                'Manage Users',
                'Add your working staffs to send invoices to clients',
                onTap: () {
                  // TODO: Navigate to manage users settings
                },
              ),
              const Gap(16),
              _buildSettingItem(
                'Products Update',
                'Make custom changes to your product table',
                onTap: () {
                  // TODO: Navigate to products update settings
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, String description, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC6C1C1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                  const Gap(8),
                  AppText(
                    description,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
