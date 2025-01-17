import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../widgets/common/app_text.dart';
import '../../../services/navigation_service.dart';

class SettingsBackButton extends StatelessWidget {
  const SettingsBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<NavigationService>().navigateToSettingsScreen(SettingsScreen.list);
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, size: 16),
          Gap(1.5),
          AppText(
            'Settings',
            size: 16,
            weight: FontWeight.w500,
          ),
          Gap(30),
        ],
      ),
    );
  }
} 

