import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/auth/business_info_screen.dart';
import '../../widgets/auth/custom_text_field.dart';
import '../../widgets/auth/gtco_logo.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/common/app_button.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedLocation;
  String? _selectedSource;

  final List<String> _locations = ['Nigeria', 'Ghana', 'Kenya', 'Other'];
  final List<String> _sources = [
    'Social Media',
    'Friend/Family',
    'Google Search',
    'Other'
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '$label${label.endsWith('?') ? '' : '*'}',
          weight: FontWeight.w500,
          color: const Color(0xFF333333),
        ),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: AppText('Choose an option', color: Colors.grey[600]),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            items: items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: AppText(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: label.contains('?')
                ? null
                : (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(32),
              const Center(child: GtcoLogo()),
              const Gap(32),
              AppText.heading(
                'Welcome!',
                textAlign: TextAlign.left,
              ),
              const Gap(8),
              AppText.subheading(
                "Let's Get You Set Up",
                textAlign: TextAlign.left,
              ),
              const Gap(32),
              CustomTextField(
                label: 'First name*',
                hint: 'Enter first name',
                controller: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const Gap(16),
              CustomTextField(
                label: 'Last name*',
                hint: 'Enter last name',
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
              const Gap(16),
              _buildDropdown(
                'Where are you located?',
                _selectedLocation,
                _locations,
                (value) => setState(() => _selectedLocation = value),
              ),
              const Gap(16),
              CustomTextField(
                label: 'Phone Number*',
                hint: '(+234) 905 691 8846',
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const Gap(16),
              _buildDropdown(
                'How did you hear about us?',
                _selectedSource,
                _sources,
                (value) => setState(() => _selectedSource = value),
              ),
              const Gap(48),
              AppButton(
                text: 'Next',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusinessInfoScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
