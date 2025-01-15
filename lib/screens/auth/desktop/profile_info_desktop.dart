import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_button_contained.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/custom_scroll_view.dart';
import '../../../widgets/auth/custom_text_field.dart';
import '../../../widgets/auth/gtco_logo.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button.dart';

class ProfileInfoDesktop extends StatelessWidget {
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
  final VoidCallback? onSubmit;

  const ProfileInfoDesktop({
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
    this.onSubmit,
  });

  Widget _buildProgressStep({
    required bool isCompleted,
    required String number,
    required String text,
    bool isActive = false,
    bool isSemiBold = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Colors.white : Colors.white.withOpacity(0.2),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Color(0xFFE04403), size: 18)
                : AppText(
                    number,
                    color:
                        isActive ? Colors.white : Colors.white.withOpacity(0.5),
                    weight: FontWeight.w600,
                    size: 24,
                  ),
          ),
        ),
        const Gap(16),
        AppText(
          text,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
          size: 24,
          weight: isSemiBold ? FontWeight.w600 : FontWeight.w500,
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(48),
              child: Form(
                key: formKey,
                child: CustomScrollWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(32),
                      const GtcoLogo(forceLarge: true),
                      const Gap(48),
                      AppText.heading(
                        'Welcome!',
                        size: 32,
                      ),
                      const Gap(8),
                      const AppText(
                        "Let's Get You Set Up",
                        size: 24,
                      ),
                      const Gap(48),
                      CustomTextField(
                        label: 'First name*',
                        hint: 'Enter first name',
                        controller: firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                      ),
                      const Gap(32),
                      CustomTextField(
                        label: 'Last name*',
                        hint: 'Enter last name',
                        controller: lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                      ),
                      const Gap(32),
                      _buildDropdown(
                        'Where are you located?',
                        selectedLocation,
                        locations,
                        onLocationChanged,
                      ),
                      const Gap(32),
                      CustomTextField(
                        label: 'Phone Number*',
                        hint: '(+234) 905 691 8846',
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),
                      const Gap(32),
                      _buildDropdown(
                        'How did you hear about us?',
                        selectedSource,
                        sources,
                        onSourceChanged,
                      ),
                      // const Spacer(),
                      const Gap(48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // TextButton(
                          //   onPressed: () => Navigator.pop(context),
                          //   child: const Text('Back'),
                          // ),
                          // const Gap(16),
                          AppButtonContained(
                            text: 'Next',
                            onPressed: onSubmit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Right side with orange background (previously on left)
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/onboarding_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressStep(
                        isCompleted: false,
                        number: "1",
                        text: "Enter your profile information",
                        isActive: true,
                        isSemiBold: true,
                      ),
                      const Gap(48),
                      _buildProgressStep(
                        isCompleted: false,
                        number: "2",
                        text: "Tell us about your business",
                        isSemiBold: true,
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
