import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/navigation_service.dart';
import '../common/app_text.dart';
import '../../screens/web/landing_screen.dart';

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
      try {
        await context.read<AuthProvider>().logout();

        if (!context.mounted) return;

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LandingScreen()),
          (route) => false,
        );
      } catch (e) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthProvider>().user;

    if (isMobile) {
      return IconButton(
        icon: CircleAvatar(
          backgroundImage: user?.company?.logo != null
              ? NetworkImage(user!.company!.logo!)
              : const AssetImage('assets/images/avatar_placeholder.png')
                  as ImageProvider,
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
                            'assets/images/avatar_placeholder.png',
                          ),
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
          CircleAvatar(
            backgroundImage: user?.company?.logo != null
                ? NetworkImage(user!.company!.logo!)
                : const AssetImage('assets/images/avatar_placeholder.png')
                    as ImageProvider,
            radius: 16,
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                '${user?.firstName ?? ''} ${user?.lastName ?? ''}'
                        .trim()
                        .isEmpty
                    ? 'User'
                    : '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                weight: FontWeight.w600,
                size: 16,
              ),
              AppText(
                // 'Merchant',
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
