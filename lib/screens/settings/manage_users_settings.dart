import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';

class ManageUsersSettings extends StatefulWidget {
  const ManageUsersSettings({super.key});

  @override
  State<ManageUsersSettings> createState() => _ManageUsersSettingsState();
}

class _ManageUsersSettingsState extends State<ManageUsersSettings> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Manage users',
            size: 24,
            weight: FontWeight.w600,
          ),
          const Gap(8),
          AppText(
            'Invite your Sales Admin to use the invoicing tool for your business',
            size: 14,
            color: Colors.grey[600],
          ),
          const Gap(32),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: FilledButton(
                      onPressed: _handleInvite,
                      child: const Text('Send Invite'),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const Gap(32),
          const AppText(
            'Invited Users',
            size: 18,
            weight: FontWeight.w600,
          ),
          const Gap(16),
          // TODO: Add list of invited users
        ],
      ),
    );
  }

  void _handleInvite() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement invite functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitation sent to ${_emailController.text}'),
        ),
      );
      _emailController.clear();
    }
  }
} 