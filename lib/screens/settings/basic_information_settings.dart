import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';

class BasicInformationSettings extends StatefulWidget {
  const BasicInformationSettings({super.key});

  @override
  State<BasicInformationSettings> createState() => _BasicInformationSettingsState();
}

class _BasicInformationSettingsState extends State<BasicInformationSettings> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Basic Information',
            size: 24,
            weight: FontWeight.w600,
          ),
          const Gap(8),
          AppText(
            'Provide basic information about your business',
            size: 14,
            color: Colors.grey[600],
          ),
          const Gap(32),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Company Details',
                  size: 18,
                  weight: FontWeight.w600,
                ),
                const Gap(24),
                _buildTextField('Company Name'),
                const Gap(16),
                _buildTextField('ID Number'),
                const Gap(16),
                _buildTextField('Email'),
                const Gap(16),
                _buildTextField('Phone Number'),
                const Gap(16),
                _buildTextField('Street'),
                const Gap(16),
                _buildTextField('Postal Code'),
                const Gap(16),
                _buildTextField('State/Province'),
                const Gap(16),
                _buildTextField('Country'),
                const Gap(32),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Save the form
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Save Changes'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
} 