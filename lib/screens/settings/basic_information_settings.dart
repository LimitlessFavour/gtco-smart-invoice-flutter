import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_button.dart';
import '../../widgets/common/app_text.dart';
import 'widgets/settings_back_button.dart';

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
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(24),
            const SettingsBackButton(),
            const Gap(24),
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
                  _buildFormField('Company Name'),
                  const Gap(24),
                  _buildFormField('ID Number'),
                  const Gap(24),
                  _buildFormField('Email'),
                  const Gap(24),
                  _buildFormField('Phone Number'),
                  const Gap(24),
                  _buildFormField('Street'),
                  const Gap(24),
                  _buildFormField('Postal Code'),
                  const Gap(24),
                  _buildFormField('State/Province'),
                  const Gap(24),
                  _buildFormField('Country'),
                  const Gap(42),
                  AppButton(
                    text: 'Save Changes',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save the form
                      }
                    },
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: FilledButton(
                  //         onPressed: () {
                  //           if (_formKey.currentState!.validate()) {
                  //             // Save the form
                  //           }
                  //         },
                  //         child: const Padding(
                  //           padding: EdgeInsets.symmetric(vertical: 16),
                  //           child: Text('Save Changes'),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const Gap(24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: AppText(
            label,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
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
        ),
      ],
    );
  }
} 