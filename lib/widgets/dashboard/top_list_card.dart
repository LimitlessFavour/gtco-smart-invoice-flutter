import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/constants/styles.dart';
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
          const Gap(30),
          ...List.generate(
            items.length,
            (index) => Column(
              children: [
                _buildListItem(items[index], index + 1),
                if (index < items.length - 1)
                   Divider(
                    height: 24,
                    thickness: 0.5,
                    color: const Color(0xFF661F01).withOpacity(0.5),
                  ),
                  const Gap(30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(TopListItem item, int index) {
    return Row(
      children: [
        // Item number
        AppText(
          '$index.',
          size: 16,
          color: const Color(0xFF6A6A6A),
          weight: FontWeight.w500,
        ),
        const Gap(8),
        // Title and value
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                item.title,
                size: 16,
                color: const Color(0xFFFF9773),
                weight: FontWeight.w500,
              ),
              AppText(
                item.value,
                size: 16,
                color: const Color(0xFF6A6A6A),
                weight: FontWeight.w500,
              ),
            ],
          ),
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
