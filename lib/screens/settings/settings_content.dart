import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/app_text.dart';
import '../../services/navigation_service.dart';
import 'basic_information_settings.dart';
import 'brand_appearance_settings.dart';
import 'manage_users_settings.dart';
import 'products_update_settings.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationService>(
      builder: (context, navigation, _) {
        switch (navigation.currentSettingsScreen) {
          case SettingsScreen.basicInformation:
            return const BasicInformationSettings();
          case SettingsScreen.brandAppearance:
            return const BrandAppearanceSettings();
          case SettingsScreen.manageUsers:
            return const ManageUsersSettings();
          case SettingsScreen.productsUpdate:
            return const ProductsUpdateSettings();
          case SettingsScreen.list:
          default:
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              width: double.maxFinite,
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
                          context
                              .read<NavigationService>()
                              .navigateToSettingsScreen(
                                  SettingsScreen.basicInformation);
                        },
                      ),
                      const Gap(24),
                      _buildSettingItem(
                        'Brand Appearance',
                        'Choose a logo and default theme for invoice sent to clients',
                        onTap: () {
                          context
                              .read<NavigationService>()
                              .navigateToSettingsScreen(
                                  SettingsScreen.brandAppearance);
                        },
                      ),
                      const Gap(24),
                      _buildSettingItem(
                        'Manage Users',
                        'Add your working staffs to send invoices to clients',
                        onTap: () {
                          context
                              .read<NavigationService>()
                              .navigateToSettingsScreen(
                                SettingsScreen.manageUsers,
                              );
                        },
                      ),
                      const Gap(24),
                      _buildSettingItem(
                        'Products Update',
                        'Make custom changes to your product table',
                        onTap: () {
                          context
                              .read<NavigationService>()
                              .navigateToSettingsScreen(
                                SettingsScreen.productsUpdate,
                              );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
        }
      },
    );
  }

  Widget _buildSettingItem(
    String title,
    String description, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      child: InkWell(
        onTap: onTap,
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
