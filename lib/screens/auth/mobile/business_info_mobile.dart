import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/layouts/web_main_layout.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_button.dart';
import '../../../widgets/auth/custom_text_field.dart';
import '../../../widgets/auth/gtco_logo.dart';
import '../../../widgets/auth/auth_background.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/image_upload_widget.dart';

class BusinessInfoMobile extends StatefulWidget {
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

  const BusinessInfoMobile({
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

  @override
  State<BusinessInfoMobile> createState() => _BusinessInfoMobileState();
}

class _BusinessInfoMobileState extends State<BusinessInfoMobile> {
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
      body: AuthBackground(
        child: Form(
          key: widget.formKey,
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
                controller: widget.companyNameController,
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
                widget.selectedIndustry,
                widget.industries,
                widget.onIndustryChanged,
              ),
              const Gap(24),
              _buildDropdown(
                'How would you describe your business?',
                widget.selectedBusinessType,
                widget.businessTypes,
                widget.onBusinessTypeChanged,
              ),
              const Gap(24),
              ImageUploadWidget(
                onImageSelected: widget.onLogoOptionChanged,
                isMobile: true,
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
