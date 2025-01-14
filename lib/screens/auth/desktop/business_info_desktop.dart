import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/custom_scroll_view.dart';
import '../../../widgets/auth/custom_text_field.dart';
import '../../../widgets/auth/gtco_logo.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button_contained.dart';
import '../../../widgets/common/image_upload.dart';

class BusinessInfoDesktop extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController companyNameController;
  final String? selectedIndustry;
  final String? selectedBusinessType;
  final String? selectedLogoOption;
  final List<String> industries;
  final List<String> businessTypes;
  final Function(String?) onIndustryChanged;
  final Function(String?) onBusinessTypeChanged;
  final Function(String?) onLogoOptionChanged;
  final VoidCallback? onSubmit;

  const BusinessInfoDesktop({
    super.key,
    required this.formKey,
    required this.companyNameController,
    required this.selectedIndustry,
    required this.selectedBusinessType,
    required this.selectedLogoOption,
    required this.industries,
    required this.businessTypes,
    required this.onIndustryChanged,
    required this.onBusinessTypeChanged,
    required this.onLogoOptionChanged,
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Colors.white : Colors.white.withOpacity(0.2),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
          color: isCompleted || isActive
              ? Colors.white
              : Colors.white.withOpacity(0.5),
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
          // Left side with form
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
                        'Tell us about your business',
                        size: 32,
                      ),
                      const Gap(8),
                      const AppText(
                        'so we can tailor your experience',
                        size: 24,
                      ),
                      const Gap(48),
                      CustomTextField(
                        label: "What is your company's name?",
                        hint: 'Enter company name',
                        controller: companyNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your company name';
                          }
                          return null;
                        },
                      ),
                      const Gap(32),
                      _buildDropdown(
                        'Where are you located?',
                        selectedIndustry,
                        industries,
                        onIndustryChanged,
                      ),
                      const Gap(32),
                      _buildDropdown(
                        'How would you describe your business?',
                        selectedBusinessType,
                        businessTypes,
                        onBusinessTypeChanged,
                      ),
                      const Gap(32),
                      const Gap(32),
                      ImageUpload(
                        onImageSelected: onLogoOptionChanged,
                        isMobile: false,
                      ),
                      const Gap(48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const AppText(
                              'Back',
                              color: Colors.black,
                              size: 20,
                              weight: FontWeight.w500,
                            ),
                          ),
                          const Gap(16),
                          AppButtonContained(
                            text: 'Save and Finish',
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
          // Right side with orange background
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
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressStep(
                        isCompleted: true,
                        number: "1",
                        text: "Enter your profile information",
                        isSemiBold: true,
                      ),
                      const Gap(48),
                      _buildProgressStep(
                        isCompleted: false,
                        number: "2",
                        text: "Tell us about your business",
                        isActive: true,
                        isSemiBold: true,
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
