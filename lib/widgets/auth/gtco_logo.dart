import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GtcoLogo extends StatelessWidget {
  const GtcoLogo({super.key, this.color, this.forceLarge = false});

  final Color? color;
  final bool forceLarge;

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;
    return SvgPicture.asset(
      forceLarge || isLargeScreen
          ? 'assets/images/smart_invoice_logo.svg'
          : 'assets/images/smart_invoice_logo_mobile.svg',
      height: isLargeScreen ? 50 : 125,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
