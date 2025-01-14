import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const CommonProgressIndicator(size: 50),
      ],
    );
  }
}

class CommonProgressIndicator extends StatelessWidget {
  const CommonProgressIndicator({
    super.key,
    this.size = 50,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Theme.of(context).primaryColor,
          size: size,
        ),
      ),
    );
  }
}
