//row widget of two texts, one is powered by gtco and the other is gtco smart invoice
import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';

class PoweredByGtco extends StatelessWidget {
  const PoweredByGtco({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            'Powered by ',
            size: 12,
            color: Colors.grey[600],
            weight: FontWeight.w400,
          ),
          AppText(
            'Gtco '.toUpperCase(),
            size: 12,
            color: theme.primaryColor,
            weight: FontWeight.w600,
          ),
          AppText(
            'Smart Invoice',
            size: 12,
            color: theme.primaryColor,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
