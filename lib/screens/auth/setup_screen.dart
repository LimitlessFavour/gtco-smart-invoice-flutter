import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/auth/profile_info_screen.dart';
import 'package:gtco_smart_invoice_flutter/utils/responsive_utils.dart';
import '../../widgets/auth/gtco_logo.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/auth/auth_background.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final large = !ResponsiveUtils.isMobileScreen(context);
    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (large) Gap(MediaQuery.of(context).size.height * 0.1),
              const Gap(32),
              const GtcoLogo(),
              const Gap(48),
              Image.asset(
                'assets/images/receipt.png',
                height: large ? 200 : 100,
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
              //app gap with height context.height * 0.2
              if (!ResponsiveUtils.isMobileScreen(context)) const Gap(48),
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
      ),
    );
  }
}
