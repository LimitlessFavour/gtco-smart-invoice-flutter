import 'package:flutter/material.dart';
import '../common/app_text.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Activity',
              size: 18,
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              icon: Icons.send,
              color: Colors.green,
              title: 'Invoice Sent',
              description: 'Invoice #1001 of amount N100,000 has been sent to Ire Victor with email irevirctor@gmail.com',
              time: '12:03 AM',
              date: '11-02-2024',
            ),
            _buildActivityItem(
              icon: Icons.receipt,
              color: Colors.red,
              title: 'Invoice Generated',
              description: 'Invoice #1001 of amount N300,000 has been generated and is read to be sent to Ire Victor.',
              time: '12:03 AM',
              date: '11-02-2024',
            ),
            _buildActivityItem(
              icon: Icons.inventory_2_outlined,
              color: Colors.blue,
              title: 'Product Created',
              description: 'A new product named Bag of Rice has been added to your product list',
              time: '12:03 AM',
              date: '11-02-2024',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String time,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, weight: FontWeight.w600),
                const SizedBox(height: 4),
                AppText(
                  description,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    AppText(
                      time,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      date,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 