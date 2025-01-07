import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/navigation_service.dart';
import 'basic_information_settings.dart';
import 'brand_appearance_settings.dart';
import 'manage_users_settings.dart';
import 'products_update_settings.dart';
import 'widgets/settings_list_view.dart';

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
            return const SettingsListView();
        }
      },
    );
  }
}
