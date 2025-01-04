import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/custom_scroll_view.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground> {
  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  Future<void> _precacheImages() async {
    await Future.wait([
      precacheImage(const AssetImage('assets/images/background.png'), context),
      precacheImage(
          const AssetImage('assets/images/background_mobile.png'), context),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

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
        Positioned.fill(
          child: Center(
            child: CustomScrollWrapper(
              child: Container(
                height: isLargeScreen ? null : 804,
                width: isLargeScreen ? 600 : 400,
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 600 : 400,
                ),
                margin: const EdgeInsets.symmetric(vertical: 24),
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 32.0,
                      bottom: 24.0,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
