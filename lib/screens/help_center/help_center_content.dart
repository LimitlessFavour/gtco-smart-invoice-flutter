import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/common/app_text.dart';

class HelpCenterContent extends StatelessWidget {
  const HelpCenterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Help Center',
            size: 24,
            weight: FontWeight.w600,
          ),
          const Gap(24),
          
          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
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
          const Gap(32),
          
          // Help Categories
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHelpCategory(
                    'Getting Started',
                    [
                      'How to create an invoice',
                      'Setting up your business profile',
                      'Adding products and services',
                      'Managing clients',
                    ],
                  ),
                  const Gap(24),
                  _buildHelpCategory(
                    'Invoicing',
                    [
                      'Creating and sending invoices',
                      'Customizing invoice templates',
                      'Setting payment terms',
                      'Managing recurring invoices',
                    ],
                  ),
                  const Gap(24),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCategory(String title, List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6C1C1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            size: 18,
            weight: FontWeight.w600,
          ),
          const Gap(16),
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