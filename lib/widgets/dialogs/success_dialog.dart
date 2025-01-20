import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../common/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;

  const AppSuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Okay',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400, // Fixed width for the dialog
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure the dialog doesn't expand
          children: [
            const Gap(8),
            // SVG Image
            SvgPicture.asset(
              'assets/icons/sent.svg', // Path to your SVG file
              width: 60,
              height: 60,
            ),
            const Gap(30),
            // Title
            AppText(
              title,
              size: 24,
              weight: FontWeight.w600,
              color: const Color(0xff464646),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            // Message
            AppText(
              message,
              size: 16,
              weight: FontWeight.w500,
              color: const Color(0xff464646),
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            // OK Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
                style: FilledButton.styleFrom(
                  backgroundColor:
                      const Color(0xffE04826), // Customize button color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: AppText(
                  buttonText,
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
