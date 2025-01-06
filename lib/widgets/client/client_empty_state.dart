import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../screens/client/client_content.dart';
import '../common/app_text.dart';

class ClientEmptyState extends StatelessWidget {
  const ClientEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_client.png',
            height: 160,
            width: 120,
          ),
          const Gap(24),
          const AppText(
            'Save Client Information here',
            size: 24,
            weight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          const Center(
            child: SizedBox(
              width: 200,
              child: CreateClientButton(),
            ),
          ),
        ],
      ),
    );
  }
} 