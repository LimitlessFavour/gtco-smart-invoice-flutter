import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../widgets/common/app_text.dart';
import '../../../services/navigation_service.dart';

class SettingsListView extends StatelessWidget {
  const SettingsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Settings',
            size: 24,
            weight: FontWeight.w600,
          ),
          const Gap(24),
          Column(
            children: [
              _buildSettingItem(
                context,
                'Basic Information',
                'Add or edit basic information about your business',
                SettingsScreen.basicInformation,
              ),
              const Gap(24),
              _buildSettingItem(
                context,
                'Brand Appearance',
                'Choose a logo and default theme for invoice sent to clients',
                SettingsScreen.brandAppearance,
              ),
              const Gap(24),
              _buildSettingItem(
                context,
                'Manage Users',
                'Add your working staffs to send invoices to clients',
                SettingsScreen.manageUsers,
              ),
              const Gap(24),
              _buildSettingItem(
                context,
                'Products Update',
                'Make custom changes to your product table',
                SettingsScreen.productsUpdate,
              ),
            ],
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
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: InkWell(
        onTap: () => context.read<NavigationService>().navigateToSettingsScreen(screen),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 0.55 * MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFC6C1C6)),
            boxShadow: const [],
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
      ),
    );
  }
} 