import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/navigation_service.dart';
import '../common/app_text.dart';
import 'package:provider/provider.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationService>(context);

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/smart_invoice_logo.png',
                  height: 40,
                ),
              ),
              const Gap(32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: AppText(
                  'MAIN MENU',
                  size: 12,
                  color: Color(0xFF464646),
                  weight: FontWeight.w600,
                ),
              ),
              _buildMenuItem(
                context,
                'Dashboard',
                'assets/icons/dashboard.svg',
                AppScreen.dashboard,
                isSelected: navigation.currentScreen == AppScreen.dashboard,
              ),
              _buildMenuItem(
                context,
                'Invoice',
                'assets/icons/invoice.svg',
                AppScreen.invoice,
                isSelected: navigation.currentScreen == AppScreen.invoice,
              ),
              _buildMenuItem(
                context,
                'Product',
                'assets/icons/product.svg',
                AppScreen.product,
                isSelected: navigation.currentScreen == AppScreen.product,
              ),
              _buildMenuItem(
                context,
                'Client',
                'assets/icons/client.svg',
                AppScreen.client,
                isSelected: navigation.currentScreen == AppScreen.client,
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: AppText(
                  'PREFERENCES',
                  size: 12,
                  color: Color(0xFF464646),
                  weight: FontWeight.w600,
                ),
              ),
              _buildMenuItem(
                context,
                'Settings',
                'assets/icons/settings.svg',
                AppScreen.settings,
                isSelected: navigation.currentScreen == AppScreen.settings,
              ),
              _buildMenuItem(
                context,
                'Help Center',
                'assets/icons/help.svg',
                AppScreen.helpCenter,
                isSelected: navigation.currentScreen == AppScreen.helpCenter,
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String icon,
    AppScreen screen, {
    bool isSelected = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : null,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(
                color: const Color(0xFFC6C1C1),
                width: 1,
              )
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.08),
                )
              ]
            : null,
      ),
      child: ListTile(
        selectedTileColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(
            icon,
            key: ValueKey(isSelected),
            color:
                isSelected ? const Color(0xFFE04403) : const Color(0xFF464646),
            width: 28,
            height: 28,
          ),
        ),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.urbanist(
            fontSize: 18, // Slightly smaller for mobile
            fontWeight: FontWeight.w600,
            color:
                isSelected ? const Color(0xFFE04403) : const Color(0xFF464646),
          ),
          child: Text(title),
        ),
        selected: isSelected,
        onTap: () {
          final navigationService =
              Provider.of<NavigationService>(context, listen: false);

          switch (screen) {
            case AppScreen.invoice:
              navigationService.navigateToInvoiceScreen(InvoiceScreen.list);
              break;
            case AppScreen.product:
              navigationService.navigateToProductScreen(ProductScreen.list);
              break;
            case AppScreen.client:
              navigationService.navigateToClientScreen(ClientScreen.list);
              break;
            case AppScreen.settings:
              navigationService.navigateToSettingsScreen(SettingsScreen.list);
              break;
            default:
              navigationService.navigateTo(screen);
          }

          if (Scaffold.of(context).hasDrawer) {
            Navigator.pop(context); // Close drawer after selection
          }
        },
      ),
    );
  }
}
