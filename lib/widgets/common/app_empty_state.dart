import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../common/app_text.dart';



class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(16),
          Image.asset(
            'assets/images/receipt.png',
            height: 50,
            width: 50,
            color: Colors.grey[600],
          ),
          const Gap(6),
          AppText(
            message,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
