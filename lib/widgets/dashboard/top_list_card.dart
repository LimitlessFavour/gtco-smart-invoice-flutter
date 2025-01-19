import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../constants/styles.dart';
import '../common/app_text.dart';
import 'dashboard_empty_states.dart';

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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            size: 20,
            weight: FontWeight.w600,
            color: const Color(0xFF6A6A6A),
          ),
          const Gap(16),
          // Show empty state if no items
          Expanded(
            child: items.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const Gap(14), // To balance the top spacing
                        ...List.generate(
                          items.length,
                          (index) => Column(
                            children: [
                              _buildListItem(items[index], index + 1),
                              if (index < items.length - 1) ...[
                                const Gap(12),
                                Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color:
                                      const Color(0xFF661F01).withOpacity(0.5),
                                ),
                                const Gap(12),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    if (title == 'Top Paying Clients') {
      return const TopPayingClientsEmptyState();
    }
    return const TopSellingProductsEmptyState();
  }

  Widget _buildListItem(TopListItem item, int index) {
    return Row(
      children: [
        AppText(
          '$index.',
          size: 16,
          weight: FontWeight.w500,
          color: const Color(0xFF6A6A6A),
        ),
        const Gap(8),
        Expanded(
          child: AppText(
            item.title,
            size: 16,
            weight: FontWeight.w500,
            color: const Color(0xFFE04403),
          ),
        ),
        AppText(
          item.value,
          size: 16,
          weight: FontWeight.w600,
          color: const Color(0xFF6A6A6A),
        ),
      ],
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
