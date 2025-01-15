import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../common/app_text.dart';

class InvoiceStatsCard extends StatelessWidget {
  final String icon;
  final String amount;
  final String label;
  final bool useImage;
  final bool isMobile;

  const InvoiceStatsCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.label,
    this.useImage = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF464646);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 34,
        // vertical: isMobile ? 12 : 28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6C1C1)),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            useImage
                ? Image.asset(
                    icon,
                    width: isMobile ? 20 : 24,
                    height: isMobile ? 20 : 24,
                    color: color,
                  )
                : SvgPicture.asset(
                    icon,
                    width: isMobile ? 20 : 24,
                    height: isMobile ? 20 : 24,
                    color: color,
                  ),
            Gap(isMobile ? 4 : 6),
            AppText(
              amount,
              size: isMobile ? 14 : 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            Gap(isMobile ? 4 : 6),
            AppText(
              label,
              size: isMobile ? 10 : 12,
              color: color,
              weight: FontWeight.w600,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
