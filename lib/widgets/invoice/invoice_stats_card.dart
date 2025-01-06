import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';

class InvoiceStatsCard extends StatelessWidget {
  final String icon;
  final String amount;
  final String label;
  final bool useImage;

  const InvoiceStatsCard({
    super.key,
    required this.icon,
    required this.amount,
    required this.label,
    this.useImage = false,
  });

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF464646);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      // padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 28),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6C1C1)),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            useImage
                ? Image.asset(icon, width: 24, height: 24, color: color)
                : SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                    color: color,
                  ),
            const Gap(6),
            AppText(
              amount,
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const Gap(6),
            AppText(
              label,
              size: 12,
              color: color,
              weight: FontWeight.w600,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
