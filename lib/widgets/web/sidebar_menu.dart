import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import '../common/app_text.dart';
import 'package:provider/provider.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationService>(context);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 250,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/smart_invoice_logo.png',
                height: 40,
              ),
            ),
            const Divider(),
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
            const Divider(),
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
          ],
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE84C3D).withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: SvgPicture.asset(
          icon,
          color: isSelected ? const Color(0xFFE84C3D) : Colors.grey[600],
        ),
        title: AppText(
          title,
          color: isSelected ? const Color(0xFFE84C3D) : Colors.grey[600],
        ),
        selected: isSelected,
        onTap: () {
          Provider.of<NavigationService>(context, listen: false)
              .navigateTo(screen);
        },
      ),
    );
  }
}
