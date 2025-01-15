import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/screens/client/mobile/client_mobile.dart';
import 'package:gtco_smart_invoice_flutter/screens/help_center/mobile/help_center_mobile.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/mobile/invoice_mobile.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/mobile/product_mobile.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/mobile/settings_mobile.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import '../services/navigation_service.dart';
import '../widgets/mobile/navigation_drawer.dart';
import '../screens/dashboard/mobile/dashboard_mobile.dart';
import 'package:provider/provider.dart';
import '../widgets/common/user_profile_section.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationService>(
      builder: (context, navigation, _) {
        return Scaffold(
          appBar: AppBar(
            title: _buildTitle(navigation.currentScreen),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {}, // TODO: Implement notifications
              ),
              const UserProfileSection(isMobile: true),
              const SizedBox(width: 8),
            ],
          ),
          drawer: const AppNavigationDrawer(),
          body: _buildContent(navigation.currentScreen),
        );
      },
    );
  }

  Widget _buildTitle(AppScreen screen) {
    String title;
    switch (screen) {
      case AppScreen.dashboard:
        title = 'Dashboard';
      case AppScreen.invoice:
        title = 'Invoices';
      case AppScreen.product:
        title = 'Products';
      case AppScreen.client:
        title = 'Clients';
      case AppScreen.settings:
        title = 'Settings';
      case AppScreen.helpCenter:
        title = 'Help Center';
    }
    return AppText(
      title,
      weight: FontWeight.w600,
      size: 24,
      color: Colors.black,
    );
  }

  Widget _buildContent(AppScreen screen) {
    switch (screen) {
      case AppScreen.dashboard:
        return const DashboardMobile();
      case AppScreen.invoice:
        return const InvoiceMobile();
      case AppScreen.product:
        return const ProductMobile();
      case AppScreen.client:
        return const ClientMobile();
      case AppScreen.settings:
        return const SettingsMobile();
      case AppScreen.helpCenter:
        return const HelpCenterMobile();
      default:
        return const DashboardMobile();
    }
  }
}
