import 'package:flutter/material.dart';

class CustomScrollWrapper extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  final ScrollController? controller;

  const CustomScrollWrapper({
    super.key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: SingleChildScrollView(
        scrollDirection: scrollDirection,
        controller: controller,
        child: child,
      ),
    );
  }
} 