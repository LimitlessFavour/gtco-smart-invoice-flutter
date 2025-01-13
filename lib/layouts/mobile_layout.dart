import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../widgets/mobile/navigation_drawer.dart';
import '../screens/dashboard/mobile/dashboard_mobile.dart';
import 'package:provider/provider.dart';

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
              const SizedBox(width: 8),
            ],
          ),
          drawer: const AppNavigationDrawer(),
          body: _buildContent(navigation.currentScreen),
          // body: Container(),
          // body: DashboardMobile(),
        );
      },
    );
  }

  Widget _buildTitle(AppScreen screen) {
    switch (screen) {
      case AppScreen.dashboard:
        return const Text('Dashboard');
      case AppScreen.invoice:
        return const Text('Invoices');
      case AppScreen.product:
        return const Text('Products');
      case AppScreen.client:
        return const Text('Clients');
      case AppScreen.settings:
        return const Text('Settings');
      case AppScreen.helpCenter:
        return const Text('Help Center');
    }
  }

  Widget _buildContent(AppScreen screen) {
    switch (screen) {
      case AppScreen.dashboard:
        return const DashboardMobile();
      default:
        return const DashboardMobile();
      // case AppScreen.invoice:
      //   return const InvoiceMobile();
      // case AppScreen.product:
      //   return const ProductMobile();
      // case AppScreen.client:
      //   return const ClientMobile();
      // case AppScreen.settings:
      //   return const SettingsMobile();
      // case AppScreen.helpCenter:
      //   return const HelpCenterMobile();
    }
  }
}
