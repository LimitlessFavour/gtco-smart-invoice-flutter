import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = activeColor ?? Theme.of(context).primaryColor;
    
    return FlutterSwitch(
      value: value,
      onToggle: onChanged,
      width: 52.0,
      height: 28.0,
      toggleSize: 24.0,
      padding: 2.0,
      activeColor: primaryColor,
      inactiveColor: Colors.grey[200]!,
      activeToggleColor: Colors.white,
      inactiveToggleColor: Colors.white,
      switchBorder: Border.all(
        color: value ? primaryColor : Colors.grey[400]!,
        width: 1.0,
      ),
    );
  }
} 