import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/custom_scroll_view.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final smallScreen = screenWidth < 400;

    return Stack(
      children: [
        Image.asset(
          isLargeScreen
              ? 'assets/images/background.png'
              : 'assets/images/background_mobile.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        SafeArea(
          child: Center(
            child: Container(
              // height: isLargeScreen
              //     ? null
              //     : smallScreen
              //         ? 600
              //         : 804,
              height: double.maxFinite,
              width: isLargeScreen
                  ? 600
                  : smallScreen
                      ? 350
                      : 400,
              constraints: BoxConstraints(
                maxWidth: isLargeScreen ? 600 : 450,
                maxHeight: isLargeScreen ? 1000 : 750,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CustomScrollWrapper(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 32.0,
                    bottom: 24.0,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
