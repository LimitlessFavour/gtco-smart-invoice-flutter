import 'package:flutter/material.dart';
import '../common/app_text.dart';

class TopListCard extends StatelessWidget {
  final String title;
  final List<TopListItem> items;

  const TopListCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              size: 18,
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildListItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(TopListItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(item.title),
          AppText(
            item.value,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class TopListItem {
  final String title;
  final String value;

  const TopListItem({
    required this.title,
    required this.value,
  });
} 