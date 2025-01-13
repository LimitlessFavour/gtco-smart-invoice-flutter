import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/web/landing_screen.dart';
import 'package:provider/provider.dart';
import '../../services/navigation_service.dart';
import '../common/app_text.dart';

class UserProfileSection extends StatelessWidget {
  final bool isMobile;

  const UserProfileSection({
    super.key,
    this.isMobile = false,
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LandingScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isMobile) {
      return IconButton(
        icon: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
          radius: 16,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/avatar_placeholder.png'),
                          radius: 32,
                        ),
                        Gap(12),
                        AppText(
                          'Bee Daisy Hair & Merchandise',
                          weight: FontWeight.w600,
                          size: 16,
                        ),
                        AppText(
                          'Sales Admin',
                          color: Colors.grey,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.settings_outlined,
                        color: theme.primaryColor),
                    title: AppText('Settings', color: theme.primaryColor),
                    onTap: () {
                      Navigator.pop(context);
                      context
                          .read<NavigationService>()
                          .navigateTo(AppScreen.settings);
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.logout_outlined, color: theme.primaryColor),
                    title: AppText('Logout', color: theme.primaryColor),
                    onTap: () {
                      Navigator.pop(context);
                      _handleLogout(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

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
              AppText('Settings', color: theme.primaryColor),
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
              AppText('Logout', color: theme.primaryColor),
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
