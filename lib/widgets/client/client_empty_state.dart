import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../screens/client/client_content.dart';
import '../common/app_text.dart';

class ClientEmptyState extends StatelessWidget {
  final bool isMobile;

  const ClientEmptyState({
    super.key,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    // return AppConfimationDialog();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_client.png',
            height: isMobile ? 120 : 160,
            width: isMobile ? 90 : 120,
          ),
          Gap(isMobile ? 16 : 24),
          AppText(
            'Save Clienst Information here',
            size: isMobile ? 18 : 24,
            weight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          Gap(isMobile ? 16 : 24),
          if (!isMobile)
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
