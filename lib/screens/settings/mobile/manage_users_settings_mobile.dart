import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/app_button.dart';

class ManageUsersSettingsMobile extends StatelessWidget {
  const ManageUsersSettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Manage Users',
          size: 18,
          weight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddUserDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Manage your team members',
              size: 14,
              color: Colors.grey[600],
            ),
            const Gap(24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3, // TODO: Replace with actual user list
              separatorBuilder: (context, index) => const Gap(16),
              itemBuilder: (context, index) => _buildUserCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person_outline),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'John Doe',
                  size: 16,
                  weight: FontWeight.w600,
                ),
                const Gap(4),
                AppText(
                  'john.doe@example.com',
                  size: 14,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            onSelected: (value) {
              // TODO: Implement edit/delete functionality
            },
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Add Team Member',
          size: 18,
          weight: FontWeight.w600,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Send Invitation',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
