import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../widgets/common/app_text.dart';
import 'widgets/settings_back_button.dart';
import 'widgets/invoice_preview.dart';

class BrandAppearanceSettings extends StatefulWidget {
  const BrandAppearanceSettings({super.key});

  @override
  State<BrandAppearanceSettings> createState() =>
      _BrandAppearanceSettingsState();
}

class _BrandAppearanceSettingsState extends State<BrandAppearanceSettings> {
  Color _selectedColor = const Color(0xFFE04403);
  ImageProvider? _selectedLogo;
  final List<Color> _themeColors = [
    const Color(0xFFE04403),
    const Color(0xFF4CAF50),
    const Color(0xFFFFEB3B),
    const Color(0xFF9E9E9E),
  ];

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedLogo = MemoryImage(bytes);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load image. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      width: double.maxFinite,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(24),
            const SettingsBackButton(),
            const Gap(24),
            const AppText(
              'Brand Appearance',
              size: 24,
              weight: FontWeight.w600,
            ),
            const Gap(8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 0.5 * MediaQuery.of(context).size.width,
              ),
              child: AppText(
                'Change company logo or set theme color. Changes apply to new and drafted invoices. '
                'You can still edit the appearance of individual documents as you work on them.',
                size: 14,
                color: Colors.grey[600],
              ),
            ),
            const Gap(32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Invoice Preview
                Expanded(
                  flex: 3,
                  child: InvoicePreview(
                    themeColor: _selectedColor,
                    logo: _selectedLogo,
                  ),
                ),
                const Gap(36),
                // Settings Panel
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          'Theme Color',
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                        const Gap(15),
                        // Theme Colors
                        Row(
                          children: _themeColors
                              .map((color) => _buildColorOption(color))
                              .toList(),
                        ),
                        const Gap(45),
                        // Logo Upload
                        const AppText(
                          'Logo',
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                        const Gap(16),
                        InkWell(
                          onTap: _pickImage,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const Gap(8),
                                  AppText(
                                    'Click to upload logo\n(Max size: 2MB)',
                                    color: Colors.grey[600],
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
          borderRadius: BorderRadius.circular(4),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
