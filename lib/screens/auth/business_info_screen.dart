import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/layouts/main_layout.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:gtco_smart_invoice_flutter/utils/responsive_utils.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../../providers/onboarding_provider.dart';
import 'desktop/business_info_desktop.dart';
import 'mobile/business_info_mobile.dart';

class BusinessInfoScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String location;
  final String? source;

  const BusinessInfoScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.location,
    this.source,
  });

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  String? _selectedIndustry;
  String? _selectedBusinessType;
  String? _selectedLogoOption;
  String? _selectedLogoPath;

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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<OnboardingProvider>();

      try {
        // First call user onboarding
        final userSuccess = await provider.onboardUser(
          firstName: widget.firstName,
          lastName: widget.lastName,
          phoneNumber: widget.phoneNumber,
          location: widget.location,
          source: widget.source,
        );

        if (!mounted) return;

        if (userSuccess == null) {
          _showErrorSnackBar(
              provider.error ?? 'Failed to complete user onboarding');
          return;
        }

        // Then call company onboarding
        final companySuccess = await provider.onboardCompany(
          companyName: _companyNameController.text,
          description: _selectedBusinessType!,
          logo: _selectedLogoPath,
        );

        if (!mounted) return;

        if (companySuccess) {
          //auth provider set user here:
          context.read<AuthProvider>().updateUser(userSuccess);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainLayout(),
            ),
          );
        } else {
          _showErrorSnackBar(
              provider.error ?? 'Failed to complete company onboarding');
        }
      } catch (e) {
        if (!mounted) return;
        _showErrorSnackBar(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        VoidCallback? submitHandler = provider.isLoading
            ? null
            : () async {
                await _handleSubmit();
              };

        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: ResponsiveUtils.isMobileScreen(context)
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
                  onLogoOptionChanged: (path) =>
                      setState(() => _selectedLogoPath = path),
                  onSubmit: submitHandler,
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
                  onLogoOptionChanged: (path) =>
                      setState(() => _selectedLogoPath = path),
                  onSubmit: submitHandler,
                ),
        );
      },
    );
  }
}
