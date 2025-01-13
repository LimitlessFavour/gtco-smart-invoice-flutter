import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/auth/custom_text_field.dart';
import '../../../widgets/auth/gtco_logo.dart';
import '../../../widgets/auth/auth_background.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button.dart';

class ProfileInfoMobile extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final String? selectedLocation;
  final String? selectedSource;
  final List<String> locations;
  final List<String> sources;
  final Function(String?) onLocationChanged;
  final Function(String?) onSourceChanged;
  final VoidCallback onSubmit;

  const ProfileInfoMobile({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.selectedLocation,
    required this.selectedSource,
    required this.locations,
    required this.sources,
    required this.onLocationChanged,
    required this.onSourceChanged,
    required this.onSubmit,
  });

  @override
  State<ProfileInfoMobile> createState() => _ProfileInfoMobileState();
}

class _ProfileInfoMobileState extends State<ProfileInfoMobile> {
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
          key: widget.formKey,
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
                controller: widget.firstNameController,
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
                controller: widget.lastNameController,
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
                widget.selectedLocation,
                widget.locations,
                widget.onLocationChanged,
              ),
              const Gap(16),
              CustomTextField(
                label: 'Phone Number*',
                hint: '(+234) 905 691 8846',
                controller: widget.phoneController,
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
                widget.selectedSource,
                widget.sources,
                widget.onSourceChanged,
              ),
              const Gap(48),
              AppButton(
                text: 'Next',
                onPressed: widget.onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
