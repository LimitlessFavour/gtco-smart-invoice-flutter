import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/auth/gtco_logo.dart';

import '../../widgets/common/app_text.dart';
import '../../widgets/common/custom_scroll_view.dart';
import '../../widgets/web/background_decorations.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const LoginScreen();
    }

    return Scaffold(
      drawer: _buildDrawer(context),
      body: Builder(
        builder: (context) => Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFEFA181),
                    Color(0xFFE87342),
                    Color(0xFFE04403),
                  ],
                  stops: [0.56, 0.81, 0.94, 1.0],
                ),
              ),
            ),
            const BackgroundDecorations(),
            CustomScrollWrapper(
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildHeroSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 900;
    // final isSmallScreen = screenWidth < 1024;

    // Adjust scale factor with minimum and maximum bounds
    final scaleFactor = (screenWidth / 1440).clamp(0.7, 1.0);

    // Responsive measurements with minimum values
    final logoWidth = (210.0 * scaleFactor).clamp(150.0, 210.0);
    final logoHeight = (60.0 * scaleFactor).clamp(45.0, 60.0);
    final navSpacing = (600.0 * scaleFactor).clamp(200.0, 600.0);
    final textSpacing = (22.0 * scaleFactor).clamp(16.0, 22.0);
    final buttonTextSize = (16.0 * scaleFactor).clamp(14.0, 16.0);
    final buttonPaddingH = (20.0 * scaleFactor).clamp(16.0, 20.0);
    final buttonPaddingV = (12.0 * scaleFactor).clamp(10.0, 12.0);
    final buttonSpacing = (20.0 * scaleFactor).clamp(16.0, 20.0);

    return Container(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 8 : 48,
        right: isSmallScreen ? 8 : 48,
        top: isSmallScreen ? 48 : 16,
        bottom: 16,
      ),
      constraints: const BoxConstraints(maxWidth: 1440),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isSmallScreen)
            Padding(
              padding: EdgeInsets.only(right: 0),
              child: IconButton(
                icon: const Icon(Icons.menu),
                hoverColor: const Color(0xFFE04403).withOpacity(0.1),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          SizedBox(
            width: logoWidth,
            height: logoHeight,
            child: const GtcoLogo(forceLarge: true),
          ),
          const Spacer(),
          if (!isSmallScreen) ...[
            // Gap(navSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Features', 'About', 'Customers', 'Pricing', 'Blog']
                  .map((text) => Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: _buildNavButton(text),
                      ))
                  .toList(),
            ),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE04403)),
                  padding: EdgeInsets.symmetric(
                    horizontal: buttonPaddingH,
                    vertical: buttonPaddingV,
                  ),
                ),
                child: AppText(
                  'Log in',
                  size: buttonTextSize,
                  weight: FontWeight.w600,
                ),
              ),
              const Gap(22),
              if (!isSmallScreen)
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE04403),
                  padding: EdgeInsets.symmetric(
                    horizontal: buttonPaddingH,
                    vertical: buttonPaddingV,
                  ),
                ),
                child: AppText(
                  'Sign up',
                  size: buttonTextSize,
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFE04403),
            ),
            child: GtcoLogo(color: Colors.white),
          ),
          ...['Features', 'About', 'Customers', 'Pricing', 'Blog'].map(
            (text) => ListTile(
              title: AppText(
                text,
                weight: FontWeight.w600,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: AppText(
        text,
        color: Colors.black,
        size: 16,
        weight: FontWeight.w600,
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 48,
        vertical: 64,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffC1C6C6)),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE04403),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const AppText(
                    'NEW',
                    size: 12,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                const AppText(
                  'Invoice for all your Clients',
                  weight: FontWeight.w500,
                ),
                const Gap(8),
              ],
            ),
          ),
          const Gap(32),
          AppText.heading(
            'Send invoices on-the-go',
            size: 48,
            textAlign: TextAlign.center,
            color: const Color(0xFFE04403),
          ),
          const Gap(16),
          AppText.heading(
            'Empower your business with simplified Invoices',
            size: 36,
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          AppText.subheading(
            'Manage your business on-the-go with SmartInvoice by GTCO. Create and\nsend clients invoices at anytime, anywhere, from any device.',
            textAlign: TextAlign.center,
          ),
          const Gap(48),
          Image.asset(
            'assets/images/landing_hero.png',
            width: MediaQuery.of(context).size.width * 0.8,
          ),
        ],
      ),
    );
  }
}
