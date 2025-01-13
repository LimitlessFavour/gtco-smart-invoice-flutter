import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button.dart';

class BrandAppearanceSettingsMobile extends StatefulWidget {
  const BrandAppearanceSettingsMobile({super.key});

  @override
  State<BrandAppearanceSettingsMobile> createState() =>
      _BrandAppearanceSettingsMobileState();
}

class _BrandAppearanceSettingsMobileState
    extends State<BrandAppearanceSettingsMobile> {
  String? _selectedLogoOption;
  String? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Brand Appearance',
          size: 18,
          weight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Customize your brand appearance',
              size: 14,
              color: Colors.grey[600],
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Logo',
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  const Gap(16),
                  _buildImageUpload(),
                  const Gap(24),
                  _buildDropdown(
                    'Logo Position',
                    _selectedLogoOption,
                    ['Left', 'Center', 'Right'],
                    (value) => setState(() => _selectedLogoOption = value),
                  ),
                  const Gap(24),
                  _buildDropdown(
                    'Invoice Theme',
                    _selectedTheme,
                    ['Classic', 'Modern', 'Professional'],
                    (value) => setState(() => _selectedTheme = value),
                  ),
                  const Gap(24),
                  AppButton(
                    text: 'Save Changes',
                    onPressed: _handleSubmit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Upload Logo',
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    // TODO: Implement save functionality
    Navigator.pop(context);
  }
}
