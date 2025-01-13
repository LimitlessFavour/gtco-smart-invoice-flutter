import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/mobile/basic_information_settings_mobile.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/mobile/brand_appearance_settings_mobile.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/mobile/manage_users_settings_mobile.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/mobile/products_update_settings_mobile.dart';
import 'package:provider/provider.dart';

import '../../../services/navigation_service.dart';
import '../../../widgets/common/app_text.dart';

class SettingsMobile extends StatelessWidget {
  const SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Settings',
            size: 20,
            weight: FontWeight.w600,
          ),
          const Gap(16),
          _buildSettingItem(
            context,
            'Basic Information',
            'Add or edit basic information about your business',
            SettingsScreen.basicInformation,
          ),
          const Gap(16),
          _buildSettingItem(
            context,
            'Brand Appearance',
            'Choose a logo and default theme for invoice sent to clients',
            SettingsScreen.brandAppearance,
          ),
          const Gap(16),
          _buildSettingItem(
            context,
            'Manage Users',
            'Add your working staffs to send invoices to clients',
            SettingsScreen.manageUsers,
          ),
          const Gap(16),
          _buildSettingItem(
            context,
            'Products Update',
            'Make custom changes to your product table',
            SettingsScreen.productsUpdate,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String description,
    SettingsScreen screen,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _getSettingsScreen(screen),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
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
                  const Gap(4),
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

  Widget _getSettingsScreen(SettingsScreen screen) {
    switch (screen) {
      case SettingsScreen.basicInformation:
        return const BasicInformationSettingsMobile();
      case SettingsScreen.brandAppearance:
        return const BrandAppearanceSettingsMobile();
      case SettingsScreen.manageUsers:
        return const ManageUsersSettingsMobile();
      case SettingsScreen.productsUpdate:
        return const ProductsUpdateSettingsMobile();
      default:
        return const SettingsMobile();
    }
  }
}
