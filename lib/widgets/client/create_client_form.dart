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
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: validator ??
              (isRequired
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return '$label is required';
                      }
                      if (label == 'Email' && !_isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      if (label == 'Phone Number' && !_isValidPhone(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    }
                  : null),
        ),
      ],
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
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

    final String clientId = isEdit
        ? widget.clientId!
        : DateTime.now().millisecondsSinceEpoch.toString();

    final client = Client(
      id: clientId,
      companyId: '1', // TODO: Get from authenticated user
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      mobileNumber: _mobileController.text,
      address: _addressController.text,
    );

    final success = isEdit
        ? await clientProvider.updateClient(client)
        : await clientProvider.createClient(client);

    if (success && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AppSuccessDialog(
          title: 'Successful!',
          message: '${isEdit ? 'Updated' : 'Created'} client successfully',
        ),
      );

      if (context.mounted) {
        navigationService.navigateToClientScreen(ClientScreen.list);
      }
    }
  }
}
