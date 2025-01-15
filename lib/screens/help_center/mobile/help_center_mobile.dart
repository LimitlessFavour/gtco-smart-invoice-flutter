import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../widgets/common/app_text.dart';

class HelpCenterMobile extends StatelessWidget {
  const HelpCenterMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for help',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const Gap(24),
          _buildHelpCategory(
            'Getting Started',
            [
              'How to create an invoice',
              'Setting up your business profile',
              'Adding products and services',
              'Managing clients',
            ],
          ),
          const Gap(16),
          _buildHelpCategory(
            'Invoicing',
            [
              'Creating and sending invoices',
              'Customizing invoice templates',
              'Setting payment terms',
              'Managing recurring invoices',
            ],
          ),
          const Gap(16),
          _buildHelpCategory(
            'Account Management',
            [
              'Managing user access',
              'Updating business information',
              'Security settings',
              'Subscription and billing',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCategory(String title, List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            size: 16,
            weight: FontWeight.w600,
          ),
          const Gap(12),
          ...items.map((item) => _buildHelpItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to help article
        },
        child: Row(
          children: [
            Expanded(
              child: AppText(
                title,
                size: 14,
                color: const Color(0xFF464646),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
