import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/client/client_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/dashboard/dashboard_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/help_center/help_center_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/invoice_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/product_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/settings_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/web/landing_screen.dart';
import 'package:gtco_smart_invoice_flutter/widgets/client/create_client_form.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import 'package:gtco_smart_invoice_flutter/widgets/product/create_product_form.dart';
import 'package:provider/provider.dart';

import '../services/navigation_service.dart';
import '../widgets/common/slide_panel.dart';
import '../widgets/web/sidebar_menu.dart';
import '../providers/client_provider.dart';

class WebMainLayout extends StatelessWidget {
  const WebMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !context.read<NavigationService>().canGoBack(),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<NavigationService>().handleBackPress();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Stack(
          children: [
            Row(
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
                              child: KeyedSubtree(
                                key: ValueKey<AppScreen>(
                                    navigation.currentScreen),
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
            // Global Slide Panels
            Consumer<NavigationService>(
              builder: (context, navigation, _) {
                return Stack(
                  children: [
                    // Client Create/Edit Panel
                    SlidePanel(
                      isOpen: navigation.currentScreen == AppScreen.client &&
                          (navigation.currentClientScreen ==
                                  ClientScreen.create ||
                              navigation.currentClientScreen ==
                                  ClientScreen.edit),
                      onClose: () =>
                          navigation.navigateToClientScreen(ClientScreen.list),
                      child: CreateClientForm(
                        onCancel: () => navigation
                            .navigateToClientScreen(ClientScreen.list),
                        client:
                            navigation.currentClientScreen == ClientScreen.edit
                                ? context
                                    .read<ClientProvider>()
                                    .getClientById(navigation.currentClientId!)
                                : null,
                      ),
                    ),
                    // Product Create Panel
                    SlidePanel(
                      isOpen: navigation.currentScreen == AppScreen.product &&
                          navigation.currentProductScreen ==
                              ProductScreen.create,
                      onClose: () => navigation
                          .navigateToProductScreen(ProductScreen.list),
                      child: CreateProductForm(
                        onCancel: () => navigation
                            .navigateToProductScreen(ProductScreen.list),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppScreen screen) {
    switch (screen) {
      case AppScreen.dashboard:
        return const DashboardContent();
      case AppScreen.invoice:
        return const InvoiceContent();
      case AppScreen.product:
        return const ProductContent();
      case AppScreen.client:
        return const ClientContent();
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
          const UserProfileSection(),
        ],
      ),
    );
  }
}

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({
    super.key,
  });

  void _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE04403),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // TODO: Add actual logout logic here with your AuthProvider
      // await context.read<AuthProvider>().logout();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LandingScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      offset: const Offset(0, -20),
      position: PopupMenuPosition.under,
      elevation: 4,
      color: Colors.white,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
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
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: theme.primaryColor,
                size: 20,
              ),
              const Gap(12),
              AppText(
                'Settings',
                color: theme.primaryColor,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                Icons.logout_outlined,
                color: theme.primaryColor,
                size: 20,
              ),
              const Gap(12),
              AppText(
                'Logout',
                color: theme.primaryColor
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'settings':
            context.read<NavigationService>().navigateTo(AppScreen.settings);
            break;
          case 'logout':
            _handleLogout(context);
            break;
        }
      },
    );
  }
}
