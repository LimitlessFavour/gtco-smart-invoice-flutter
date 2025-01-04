import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundDecorations extends StatelessWidget {
  const BackgroundDecorations({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: 100,
            top: 150,
            child: SvgPicture.asset('assets/images/plus-decoration.svg'),
          ),
          Positioned(
            right: 150,
            top: 200,
            child: SvgPicture.asset('assets/images/plus-decoration.svg'),
          ),
          Positioned(
            left: 200,
            bottom: 150,
            child: SvgPicture.asset('assets/images/plus-decoration.svg'),
          ),
          Positioned(
            right: 100,
            bottom: 200,
            child: SvgPicture.asset('assets/images/plus-decoration.svg'),
          ),
        ],
      ),
    );
  }
} 