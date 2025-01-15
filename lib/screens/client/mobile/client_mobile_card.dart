import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/client.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';

class ClientMobileCard extends StatelessWidget {
  final Client client;

  const ClientMobileCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  client.fullName,
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('View Details'),
                    onTap: () => _navigateToClientDetails(context),
                  ),
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () => _handleEdit(context),
                  ),
                  PopupMenuItem(
                    child: const Text('Delete'),
                    onTap: () => _handleDelete(context),
                  ),
                ],
              ),
            ],
          ),
          const Gap(8),
          _buildInfoItem('Email', client.email),
          const Gap(8),
          _buildInfoItem('Phone', client.phoneNumber),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          size: 12,
          color: Colors.grey[600],
        ),
        const Gap(4),
        AppText(
          value,
          size: 14,
          weight: FontWeight.w500,
        ),
      ],
    );
  }

  void _navigateToClientDetails(BuildContext context) {
    // Implement navigation to client details
  }

  void _handleEdit(BuildContext context) {
    // Implement edit action
  }

  void _handleDelete(BuildContext context) {
    // Implement delete action
  }
}
