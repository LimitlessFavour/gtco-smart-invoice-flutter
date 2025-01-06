import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/dashboard/dashboard_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/help/help_center_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/invoice_list_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/settings_content.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../widgets/web/sidebar_menu.dart';

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
                const TopBar(),
                Expanded(
                  child: Consumer<NavigationService>(
                    builder: (context, navigation, _) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey<AppScreen>(navigation.currentScreen),
                          child: _buildContent(navigation.currentScreen),
                        ),
                      );
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

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0XFFFAFAFA),
      ),
      child: Row(
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/icons/notification.svg',
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
            width: 24,
            height: 24,
          ),
          const Gap(40),
          Row(
            children: [
              const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/avatar_placeholder.png'),
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    'Bee Daisy Hair & Merchandise',
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                  AppText(
                    'Sales Admin',
                    color: Colors.grey[600],
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
