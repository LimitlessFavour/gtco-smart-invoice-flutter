import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/client/client_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/dashboard/dashboard_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/help_center/help_center_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/invoice/invoice_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/product_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/settings/settings_content.dart';
import 'package:gtco_smart_invoice_flutter/widgets/client/create_client_form.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/user_profile_section.dart';
import 'package:gtco_smart_invoice_flutter/widgets/product/create_product_form.dart';
import 'package:provider/provider.dart';

import '../services/navigation_service.dart';
import '../widgets/common/slide_panel.dart';
import '../widgets/web/sidebar_menu.dart';
import '../providers/client_provider.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

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
                        clientId:
                            navigation.currentClientScreen == ClientScreen.edit
                                ? navigation.currentClientId
                                : null,
                      ),
                    ),
                    // Product Create Panel
                    SlidePanel(
                      isOpen: navigation.currentScreen == AppScreen.product &&
                          (navigation.currentProductScreen ==
                                  ProductScreen.create ||
                              navigation.currentProductScreen ==
                                  ProductScreen.edit),
                      onClose: () => navigation
                          .navigateToProductScreen(ProductScreen.list),
                      child: Builder(
                        builder: (context) {
                          debugPrint('=== SlidePanel Builder ===');
                          debugPrint(
                              'currentProductScreen: ${navigation.currentProductScreen}');
                          debugPrint(
                              'currentProductId: ${navigation.currentProductId}');
                          debugPrint('========================');

                          return CreateProductForm(
                            isEdit: navigation.currentProductScreen ==
                                ProductScreen.edit,
                            productId: navigation.currentProductId,
                            onCancel: () => navigation
                                .navigateToProductScreen(ProductScreen.list),
                          );
                        },
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
