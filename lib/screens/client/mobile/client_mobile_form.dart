import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../models/client.dart';
import '../../../providers/client_provider.dart';
import '../../../services/navigation_service.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/dialogs/success_dialog.dart';
import 'package:provider/provider.dart';

class ClientMobileForm extends StatefulWidget {
  final Client? client;

  const ClientMobileForm({
    super.key,
    this.client,
  });

  @override
  State<ClientMobileForm> createState() => _ClientMobileFormState();
}

class _ClientMobileFormState extends State<ClientMobileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  bool get isEdit => widget.client != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: isEdit
          ? '${widget.client!.firstName} ${widget.client!.lastName}'
          : '',
    );
    _phoneController = TextEditingController(
      text: isEdit ? widget.client!.phoneNumber : '',
    );
    _emailController = TextEditingController(
      text: isEdit ? widget.client!.email : '',
    );
    _addressController = TextEditingController(
      text: isEdit ? widget.client!.address : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Client Name',
            controller: _nameController,
            isRequired: true,
          ),
          const Gap(16),
          _buildTextField(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            isRequired: true,
          ),
          const Gap(16),
          _buildTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
          ),
          const Gap(16),
          _buildTextField(
            label: 'Address',
            controller: _addressController,
            maxLines: 3,
            isRequired: true,
          ),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE04403),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: AppText(
                isEdit ? 'Update Client' : 'Create Client',
                color: Colors.white,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '$label${isRequired ? ' *' : ''}',
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label is required';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final clientProvider = context.read<ClientProvider>();
      final navigationService = context.read<NavigationService>();

      final client = Client(
        id: isEdit
            ? widget.client!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        companyId: '1', // TODO: Get from authenticated user
        firstName: _nameController.text.split(' ').first,
        lastName: _nameController.text.split(' ').skip(1).join(' '),
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
      );

      final success = isEdit
          ? await clientProvider.updateClient(client)
          : await clientProvider.createClient(client);

      if (success && context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SuccessDialog(
            message: '${isEdit ? 'Updated' : 'Created'} client successfully',
          ),
        );

        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }
  }
}
