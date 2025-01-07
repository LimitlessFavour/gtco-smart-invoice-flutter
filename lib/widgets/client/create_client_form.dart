import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../common/app_text.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../services/navigation_service.dart';
import '../dialogs/success_dialog.dart';
import '../common/loading_overlay.dart';
import '../dialogs/basic_confirmation_dialog.dart';

class CreateClientForm extends StatefulWidget {
  final VoidCallback onCancel;
  final Client? client;

  const CreateClientForm({
    super.key,
    required this.onCancel,
    this.client,
  });

  @override
  State<CreateClientForm> createState() => _CreateClientFormState();
}

class _CreateClientFormState extends State<CreateClientForm> {
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
    return Consumer<ClientProvider>(
      builder: (context, provider, child) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        isEdit ? 'Edit Client' : 'New Client',
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                      IconButton(
                        onPressed: widget.onCancel,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Form Fields
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
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
                      ],
                    ),
                  ),
                ),
                // Actions
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.onCancel,
                        child: const Text('Cancel'),
                      ),
                      const Gap(16),
                      ElevatedButton(
                        onPressed: _showConfirmation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(isEdit ? 'Update' : 'Save'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
              borderRadius: BorderRadius.circular(8),
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

  void _showConfirmation() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => BasicConfirmationDialog(
          title: isEdit ? 'Update Client' : 'Create Client',
          message: isEdit
              ? 'Are you sure you want to update this client?'
              : 'Are you sure you want to create this client?',
          confirmText: isEdit ? 'Update' : 'Create',
          onConfirm: _handleSubmit,
        ),
      );
    }
  }

  void _handleSubmit() async {
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
        navigationService.navigateToClientScreen(ClientScreen.list);
      }
    }
  }
}
