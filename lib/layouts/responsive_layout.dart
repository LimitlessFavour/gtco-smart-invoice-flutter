import 'package:flutter/material.dart';
import '../widgets/web/sidebar_menu.dart';
import '../widgets/mobile/navigation_drawer.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const ResponsiveLayout({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 768;

    if (isWeb) {
      return Row(
        children: [
          const SidebarMenu(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(title),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/avatar_placeholder.png'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              body: child,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const AppNavigationDrawer(),
      body: child,
    );
  }
}
