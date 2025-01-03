import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GtcoLogo extends StatelessWidget {
  const GtcoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/smart_invoice_logo.svg',
      height: 40,
    );
  }
}
