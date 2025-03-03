import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/screens/auth/business_info_screen.dart';
import 'package:gtco_smart_invoice_flutter/utils/fade_page_route.dart';
import 'package:gtco_smart_invoice_flutter/utils/responsive_utils.dart';
import 'mobile/profile_info_mobile.dart';
import 'desktop/profile_info_desktop.dart';
import 'package:provider/provider.dart';
import '../../../providers/onboarding_provider.dart';

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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessInfoScreen(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            phoneNumber: _phoneController.text,
            location: _selectedLocation!,
            source: _selectedSource,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        VoidCallback? submitHandler = provider.isLoading
            ? null
            : () {
                _handleSubmit();
              };

        return ResponsiveUtils.isMobileScreen(context)
            ? ProfileInfoMobile(
                formKey: _formKey,
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneController: _phoneController,
                selectedLocation: _selectedLocation,
                selectedSource: _selectedSource,
                locations: _locations,
                sources: _sources,
                onLocationChanged: (value) =>
                    setState(() => _selectedLocation = value),
                onSourceChanged: (value) =>
                    setState(() => _selectedSource = value),
                onSubmit: submitHandler,
              )
            : ProfileInfoDesktop(
                formKey: _formKey,
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneController: _phoneController,
                selectedLocation: _selectedLocation,
                selectedSource: _selectedSource,
                locations: _locations,
                sources: _sources,
                onLocationChanged: (value) =>
                    setState(() => _selectedLocation = value),
                onSourceChanged: (value) =>
                    setState(() => _selectedSource = value),
                onSubmit: submitHandler,
              );
      },
    );
  }
}
