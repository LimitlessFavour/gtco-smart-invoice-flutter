import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class CompanyLogo extends StatelessWidget {
  final double height;
  final String fallbackAsset;

  const CompanyLogo({
    super.key,
    this.height = 40,
    this.fallbackAsset = 'assets/images/gtco_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        final logoUrl = provider.user?.company?.logo;

        if (logoUrl == null || logoUrl.isEmpty) {
          return Image.asset(
            fallbackAsset,
            height: height,
          );
        }

        return Image.network(
          logoUrl,
          height: height * 1.5,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              fallbackAsset,
              height: height,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return SizedBox(
              height: height,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: const Color(0xFFE04403),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
