import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/providers/auth_provider.dart';
import 'package:gtco_smart_invoice_flutter/widgets/client/client_action_button.dart';
import 'package:gtco_smart_invoice_flutter/widgets/dialogs/confirmation_dialog.dart';
import '../common/app_text.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../services/navigation_service.dart';
import '../dialogs/success_dialog.dart';
import '../common/loading_overlay.dart';

class CreateClientForm extends StatefulWidget {
  final VoidCallback onCancel;
  final String? clientId;

  const CreateClientForm({
    super.key,
    required this.onCancel,
    this.clientId,
  });

  @override
  State<CreateClientForm> createState() => _CreateClientFormState();
}

class _CreateClientFormState extends State<CreateClientForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  Client? _client;
  bool _isLoading = false;

  bool get isEdit => widget.clientId != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadClient();
      });
    }
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _mobileController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
  }

  Future<void> _loadClient() async {
    setState(() => _isLoading = true);
    try {
      final client =
          await context.read<ClientProvider>().getClientById(widget.clientId!);
      if (mounted && client != null) {
        setState(() {
          _client = client;
          _firstNameController.text = client.firstName;
          _lastNameController.text = client.lastName;
          _phoneController.text = client.phoneNumber;
          _mobileController.text = client.mobileNumber;
          _emailController.text = client.email;
          _addressController.text = client.address;
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ClientProvider>(
      builder: (context, provider, child) {
        return LoadingOverlay(
          isLoading: _isLoading,
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
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: 'First Name',
                                controller: _firstNameController,
                                isRequired: true,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: _buildTextField(
                                label: 'Last Name',
                                controller: _lastNameController,
                                isRequired: true,
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        _buildTextField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            if (!_isValidPhone(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const Gap(16),
                        _buildTextField(
                          label: 'Mobile Number',
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mobile number is required';
                            }
                            if (!_isValidPhone(value)) {
                              return 'Please enter a valid mobile number';
                            }
                            return null;
                          },
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
                        onPressed: () {
                          _clearForm();
                          widget.onCancel();
                        },
                        child: const AppText('Cancel'),
                      ),
                      const Gap(16),
                      ClientActionButton(
                        isEdit: isEdit,
                        formKey: _formKey,
                        formData: {
                          'firstName': _firstNameController.text,
                          'lastName': _lastNameController.text,
                          'phoneNumber': _phoneController.text,
                          'mobileNumber': _mobileController.text,
                          'email': _emailController.text,
                          'address': _addressController.text,
                        },
                        onCancel: widget.onCancel,
                        clientId: widget.clientId,
                        onSuccess: _clearForm,
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
    TextInputType? keyboardType,
    bool isRequired = false,
    int maxLines = 1,
    String? Function(String?)? validator,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE04403)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: validator ??
              (value) {
                if (isRequired && (value == null || value.isEmpty)) {
                  return '$label is required';
                }
                return null;
              },
        ),
      ],
    );
  }

  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }

  void _showConfirmation() async {
    if (_formKey.currentState!.validate()) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AppConfirmationDialog(
          title: isEdit ? 'Update Client' : 'Create Client',
          content: isEdit
              ? 'Are you sure you want to update this client?'
              : 'Are you sure you want to create this client?',
          confirmText: isEdit ? 'Update' : 'Create',
          cancelText: 'Cancel',
        ),
      );
      if (confirmed == true) {
        _handleSubmit();
      }
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Additional validation
    if (!_isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isValidPhone(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = context.read<AuthProvider>().user;
    final clientProvider = context.read<ClientProvider>();
    final navigationService = context.read<NavigationService>();

    // Trim whitespace from all fields
    final client = Client(
      id: isEdit
          ? widget.clientId!
          : DateTime.now().millisecondsSinceEpoch.toString(),
      companyId: user?.company?.id ?? '1',
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      address: _addressController.text.trim(),
    );

    // Validate that at least one field has content
    if (client.firstName.isEmpty &&
        client.lastName.isEmpty &&
        client.email.isEmpty &&
        client.phoneNumber.isEmpty &&
        client.address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in at least one field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final success = await clientProvider.submitClient(client, isEdit);

      if (success && context.mounted) {
        _clearForm();
        clientProvider.clearForm();

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AppSuccessDialog(
            title: 'Successful!',
            message: '${isEdit ? 'Updated' : 'Created'} client successfully',
          ),
        );

        if (context.mounted) {
          widget.onCancel(); // Dismiss the slide-in
          navigationService.navigateToClientScreen(ClientScreen.list);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    _mobileController.clear();
    _emailController.clear();
    _addressController.clear();
  }
}
