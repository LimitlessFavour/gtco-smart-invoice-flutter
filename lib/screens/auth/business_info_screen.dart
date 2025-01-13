import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/layouts/web_main_layout.dart';
import 'package:gtco_smart_invoice_flutter/utils/responsive_utils.dart';
import 'mobile/business_info_mobile.dart';
import 'desktop/business_info_desktop.dart';

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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WebMainLayout(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.isMobileScreen(context)
        ? BusinessInfoMobile(
            formKey: _formKey,
            companyNameController: _companyNameController,
            selectedIndustry: _selectedIndustry,
            selectedBusinessType: _selectedBusinessType,
            selectedLogoOption: _selectedLogoOption,
            industries: _industries,
            businessTypes: _businessTypes,
            onIndustryChanged: (value) =>
                setState(() => _selectedIndustry = value),
            onBusinessTypeChanged: (value) =>
                setState(() => _selectedBusinessType = value),
            onLogoOptionChanged: (value) =>
                setState(() => _selectedLogoOption = value),
            onSubmit: _handleSubmit,
          )
        : BusinessInfoDesktop(
            formKey: _formKey,
            companyNameController: _companyNameController,
            selectedIndustry: _selectedIndustry,
            selectedBusinessType: _selectedBusinessType,
            selectedLogoOption: _selectedLogoOption,
            industries: _industries,
            businessTypes: _businessTypes,
            onIndustryChanged: (value) =>
                setState(() => _selectedIndustry = value),
            onBusinessTypeChanged: (value) =>
                setState(() => _selectedBusinessType = value),
            onLogoOptionChanged: (value) =>
                setState(() => _selectedLogoOption = value),
            onSubmit: _handleSubmit,
          );
  }
}
