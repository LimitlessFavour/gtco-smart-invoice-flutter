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
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Row(
          children: [
            const SidebarMenu(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFFFAFAFA),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {},
                        ),
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
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
