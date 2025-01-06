import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/auth/profile_info_screen.dart';
import '../../widgets/auth/gtco_logo.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/auth/auth_background.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(32),
            const GtcoLogo(),
            const Gap(48),
            Image.asset(
              'assets/images/receipt.png',
              height: 200,
              fit: BoxFit.contain,
            ),
            const Gap(32),
            AppText.heading(
              'Set up your business',
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            AppText.subheading(
              'Create professional invoices, track payments, and manage your business finances all in one place.',
              textAlign: TextAlign.center,
            ),
            const Gap(48),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileInfoScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: AppText.button('Get Started'),
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }
}
