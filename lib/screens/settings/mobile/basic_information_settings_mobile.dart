import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button.dart';

class BasicInformationSettingsMobile extends StatefulWidget {
  const BasicInformationSettingsMobile({super.key});

  @override
  State<BasicInformationSettingsMobile> createState() =>
      _BasicInformationSettingsMobileState();
}

class _BasicInformationSettingsMobileState
    extends State<BasicInformationSettingsMobile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Basic Information',
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
              'Provide basic information about your business',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'Company Details',
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    const Gap(16),
                    _buildFormField('Company Name'),
                    const Gap(16),
                    _buildFormField('ID Number'),
                    const Gap(16),
                    _buildFormField('Email'),
                    const Gap(16),
                    _buildFormField('Phone Number'),
                    const Gap(16),
                    _buildFormField('Street'),
                    const Gap(16),
                    _buildFormField('Postal Code'),
                    const Gap(16),
                    _buildFormField('State/Province'),
                    const Gap(16),
                    _buildFormField('Country'),
                    const Gap(24),
                    AppButton(
                      text: 'Save Changes',
                      onPressed: _handleSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      Navigator.pop(context);
    }
  }
}
