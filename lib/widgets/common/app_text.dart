import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.size = 16,
    this.weight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  // Predefined styles
  factory AppText.heading(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
  }) =>
      AppText(
        text,
        key: key,
        size: 24,
        weight: FontWeight.w600,
        color: color ?? const Color(0xFF333333),
        textAlign: textAlign,
      );

  factory AppText.subheading(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
  }) =>
      AppText(
        text,
        key: key,
        size: 16,
        weight: FontWeight.w500,
        color: color ?? const Color(0xFF666666),
        textAlign: textAlign,
      );

  factory AppText.button(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
  }) =>
      AppText(
        text,
        key: key,
        size: 16,
        weight: FontWeight.w500,
        color: color ?? Colors.white,
        textAlign: textAlign,
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
} 