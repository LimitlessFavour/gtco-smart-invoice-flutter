import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../services/navigation_service.dart';
import '../common/app_text.dart';
import '../dialogs/success_dialog.dart';

class ClientActionButton extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic> Function() formData;
  final VoidCallback? onCancel;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onSuccess;
  final String? clientId;

  const ClientActionButton({
    super.key,
    this.isEdit = false,
    required this.formData,
    this.onCancel,
    required this.formKey,
    this.onSuccess,
    this.clientId,
  });

  @override
  State<ClientActionButton> createState() => _ClientActionButtonState();
}

class _ClientActionButtonState extends State<ClientActionButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // check height of the screen
    final screenHeight = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE04403),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: screenHeight > 600 ? 16 : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  widget.isEdit ? 'Save Changes' : 'Create Client',
                  color: Colors.white,
                  weight: FontWeight.w500,
                ),
                const Gap(4),
                const Icon(Icons.check, color: Colors.white, size: 20),
              ],
            ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_isLoading) return;

    // Save the form to ensure the latest values are available
    widget.formKey.currentState!.save();

    if (!widget.formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AppText('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = context.read<ClientProvider>();
      final navigationService = context.read<NavigationService>();
      final user = context.read<AuthProvider>().user;

      // Get the latest form data
      final formData = widget.formData();

      // Validate all required fields are filled
      if (formData.values.any((field) => field.toString().trim().isEmpty)) {
        //print the form data
        debugPrint('Form data: $formData');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: AppText('Please fill in all required fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final client = Client(
        id: widget.isEdit
            ? widget.clientId!
            : DateTime.now().millisecondsSinceEpoch.toString(),
        companyId: user?.company?.id ?? '1',
        firstName: formData['firstName']!.toString(),
        lastName: formData['lastName']!.toString(),
        email: formData['email']!.toString(),
        phoneNumber: formData['phoneNumber']!.toString(),
        mobileNumber: formData['mobileNumber']!.toString(),
        address: formData['address']!.toString(),
      );

      final success = await provider.submitClient(client, widget.isEdit);

      if (success && context.mounted) {
        widget.onSuccess?.call();
        widget.onCancel?.call();
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AppSuccessDialog(
            title: 'Successful!',
            message: widget.isEdit
                ? 'Client updated successfully'
                : 'Client created successfully',
          ),
        );
        if (context.mounted) {
          widget.onSuccess?.call();
          navigationService.navigateToClientScreen(ClientScreen.list);
        }
      } else if (context.mounted && provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(provider.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
