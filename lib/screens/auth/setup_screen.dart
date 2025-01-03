import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/auth/gtco_logo.dart';
import '../../widgets/common/app_text.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GtcoLogo(),
              const Spacer(),
              Image.asset(
                'assets/images/receipt.png',
                height: 200,
                fit: BoxFit.contain,
              ),
              const Gap(32),
              AppText.heading('Set up your business',
                  textAlign: TextAlign.center),
              const Gap(16),
              AppText.subheading(
                'Create professional invoices, track payments, and manage your business finances all in one place.',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Navigate to business info screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
