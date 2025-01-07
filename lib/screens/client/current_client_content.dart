import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/client.dart';
import '../../widgets/common/app_text.dart';
import '../../services/navigation_service.dart';
import '../../providers/client_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/dialogs/confirmation_dialog.dart';
import '../../widgets/dialogs/success_dialog.dart';

class CurrentClientContent extends StatelessWidget {
  final Client client;

  const CurrentClientContent({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC6C1C1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context
                          .read<NavigationService>()
                          .navigateToClientScreen(ClientScreen.list),
                    ),
                    const Gap(16),
                    AppText(
                      client.fullName,
                      size: 24,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _handleEdit(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    const Gap(16),
                    TextButton.icon(
                      onPressed: () => _handleDelete(context),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(24),
          // Client Details
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC6C1C1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Full Name', client.fullName),
                const Gap(16),
                _buildDetailRow('Email', client.email),
                const Gap(16),
                _buildDetailRow('Phone Number', client.phoneNumber),
                const Gap(16),
                _buildDetailRow('Address', client.address),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: AppText(
            label,
            weight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: AppText(value),
        ),
      ],
    );
  }

  void _handleEdit(BuildContext context) {
    context
        .read<NavigationService>()
        .navigateToClientScreen(ClientScreen.edit, clientId: client.id);
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Client',
        message: 'Are you sure you want to delete ${client.fullName}?',
        confirmText: 'Delete',
        cancelText: 'Cancel',
        isDestructive: true,
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await context.read<ClientProvider>().deleteClient(client.id);

      if (success && context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => const SuccessDialog(
            message: 'Client deleted successfully',
          ),
        );

        if (context.mounted) {
          context
              .read<NavigationService>()
              .navigateToClientScreen(ClientScreen.list);
        }
      }
    }
  }
}
