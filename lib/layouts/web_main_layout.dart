import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/screens/dashboard/dashboard_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/help/help_center_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/invoice_list_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/settings_content.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../widgets/web/sidebar_menu.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/invoice/invoice_list_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/help/help_center_screen.dart';

class WebMainLayout extends StatelessWidget {
  const WebMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        children: [
          const SidebarMenu(),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0XFFFFFFFF),
                    border: Border.all(
                      color: const Color(0XFFC6C1C1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Consumer<NavigationService>(
                        builder: (context, navigation, _) {
                          return Text(
                            _getTitle(navigation.currentScreen),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                      ),
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/avatar_placeholder.png'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<NavigationService>(
                    builder: (context, navigation, _) {
                      return _buildContent(navigation.currentScreen);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(AppScreen screen) {
    switch (screen) {
      case AppScreen.dashboard:
        return 'Overview';
      case AppScreen.invoice:
        return 'Invoices';
      case AppScreen.product:
        return 'Products';
      case AppScreen.client:
        return 'Clients';
      case AppScreen.settings:
        return 'Settings';
      case AppScreen.helpCenter:
        return 'Help Center';
    }
  }

  Widget _buildContent(AppScreen screen) {
    switch (screen) {
      case AppScreen.dashboard:
        return const DashboardContent();
      case AppScreen.invoice:
        return const InvoiceListContent();
      case AppScreen.product:
        return const Center(child: Text('Product Screen - Coming Soon'));
      case AppScreen.client:
        return const Center(child: Text('Client Screen - Coming Soon'));
      case AppScreen.settings:
        return const SettingsContent();
      case AppScreen.helpCenter:
        return const HelpCenterContent();
    }
  }
}
