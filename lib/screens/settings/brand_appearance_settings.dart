import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';

class BrandAppearanceSettings extends StatefulWidget {
  const BrandAppearanceSettings({super.key});

  @override
  State<BrandAppearanceSettings> createState() => _BrandAppearanceSettingsState();
}

class _BrandAppearanceSettingsState extends State<BrandAppearanceSettings> {
  Color _selectedColor = const Color(0xFFE04403);
  final List<Color> _themeColors = [
    const Color(0xFFE04403),
    const Color(0xFF4CAF50),
    const Color(0xFFFFEB3B),
    const Color(0xFF9E9E9E),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Brand Appearance',
            size: 24,
            weight: FontWeight.w600,
          ),
          const Gap(8),
          AppText(
            'Change company logo or set theme color. Changes apply to new and drafted invoices.',
            size: 14,
            color: Colors.grey[600],
          ),
          const Gap(32),
          const AppText(
            'Template',
            size: 18,
            weight: FontWeight.w600,
          ),
          const Gap(24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'Theme Color',
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Row(
                      children: _themeColors.map((color) => _buildColorOption(color)).toList(),
                    ),
                  ],
                ),
                const Gap(24),
                const AppText(
                  'Logo',
                  size: 16,
                  weight: FontWeight.w600,
                ),
                const Gap(16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey[400]),
                        const Gap(8),
                        AppText(
                          'Drag your logo here\nor select a file',
                          color: Colors.grey[600],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
} 