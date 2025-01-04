import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/auth/custom_text_field.dart';
import '../../widgets/auth/gtco_logo.dart';
import '../../widgets/auth/auth_background.dart';
import '../../widgets/common/app_text.dart';
import '../../screens/auth/profile_info_screen.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  String? _selectedIndustry;
  String? _selectedBusinessType;
  String? _selectedLogoOption;

  final List<String> _industries = [
    'Technology',
    'Retail',
    'Healthcare',
    'Manufacturing',
    'Finance',
    'Other'
  ];

  final List<String> _businessTypes = [
    'Small Business',
    'Enterprise',
    'Startup',
    'Freelancer'
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(32),
              const GtcoLogo(),
              const Gap(32),
              AppText.subheading(
                'Tell us about your business so we can tailor your experience',
                textAlign: TextAlign.left,
              ),
              const Gap(32),
              CustomTextField(
                label: "What is your company's name?",
                hint: 'Enter company name',
                controller: _companyNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your company name';
                  }
                  return null;
                },
              ),
              const Gap(24),
              _buildDropdown(
                'Where are you located?',
                _selectedIndustry,
                _industries,
                (String? value) {
                  setState(() {
                    _selectedIndustry = value;
                  });
                },
              ),
              const Gap(24),
              _buildDropdown(
                'How would you describe your business?',
                _selectedBusinessType,
                _businessTypes,
                (String? value) {
                  setState(() {
                    _selectedBusinessType = value;
                  });
                },
              ),
              const Gap(24),
              _buildDropdown(
                'Upload your business logo',
                _selectedLogoOption,
                ['Take a photo', 'Choose from gallery'],
                (String? value) {
                  setState(() {
                    _selectedLogoOption = value;
                  });
                },
              ),
              const Gap(48),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileInfoScreen(),
                      ),
                    );
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: AppText.button('Next'),
              ),
            ],
          ),
        ),
      ),
    );
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
          label,
          weight: FontWeight.w500,
          color: const Color(0xFF333333),
        ),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an option';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
