import 'package:flutter/material.dart';

class SlidePanel extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final Widget child;

  const SlidePanel({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop for clicking outside
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          right: isOpen ? 0 : -800,
          top: 0,
          bottom: 0,
          width: 800,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! > 0) {
                onClose();
              }
            },
            child: Material(
              elevation: 16,
              type: MaterialType.transparency,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  // border: Border.all(color: const Color(0xFFC6C1C6)),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
