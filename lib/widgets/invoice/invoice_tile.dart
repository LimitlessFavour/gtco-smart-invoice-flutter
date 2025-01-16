import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/invoice.dart';
import '../../services/navigation_service.dart';
import '../common/app_text.dart';

class InvoiceTile extends StatelessWidget {
  final Invoice invoice;
  final bool isMobile;

  const InvoiceTile({
    super.key,
    required this.invoice,
    this.isMobile = false,
  });

  void _handleNavigation(BuildContext context) {
    // Wrap the navigation in a post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationService>().navigateToInvoiceScreen(
            InvoiceScreen.view,
            invoiceId: invoice.id.toString(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileTile(context);
    }
    return _buildDesktopTile(context);
  }

  Widget _buildMobileTile(BuildContext context) {
    return InkWell(
      onTap: () => _handleNavigation(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFC6C1C1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  '#${invoice.invoiceNumber}',
                  size: 14,
                  weight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
                _buildStatusBadge(invoice.status),
              ],
            ),
            const Gap(12),
            AppText(
              invoice.client.fullName,
              size: 16,
              weight: FontWeight.w500,
              color: const Color(0xFF344054),
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  DateFormat('dd.MM.yyyy').format(invoice.dueDate),
                  size: 14,
                  color: const Color(0xFF667085),
                ),
                AppText(
                  '₦${NumberFormat('#,###').format(invoice.totalAmount)}',
                  size: 14,
                  weight: FontWeight.w600,
                  color: const Color(0xFF344054),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTile(BuildContext context) {
    return InkWell(
      onTap: () => _handleNavigation(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: AppText(
                  '#${invoice.invoiceNumber}',
                  size: 14,
                  weight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              ),
              Expanded(
                flex: 3,
                child: AppText(
                  invoice.client.fullName,
                  size: 14,
                  weight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              ),
              Expanded(
                flex: 2,
                child: AppText(
                  DateFormat('dd.MM.yyyy').format(invoice.dueDate),
                  size: 14,
                  color: const Color(0xFF667085),
                ),
              ),
              Expanded(
                flex: 2,
                child: AppText(
                  '₦${NumberFormat('#,###').format(invoice.totalAmount)}',
                  size: 14,
                  weight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              ),
              _buildStatusBadge(invoice.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText =
        status.substring(0, 1).toUpperCase() + status.substring(1);

    switch (status.toLowerCase()) {
      case 'paid':
        backgroundColor = const Color(0xFFECFDF3);
        textColor = const Color(0xFF027A48);
        break;
      case 'unpaid':
        backgroundColor = const Color(0xffFCB300).withOpacity(0.1);
        textColor = const Color(0xffFCB300);
        break;
      case 'overdue':
        backgroundColor = const Color(0xFFFEF3F2);
        textColor = const Color(0xFFB42318);
        break;
      case 'drafted':
        backgroundColor = const Color(0xFFF2F4F7);
        textColor = const Color(0xFF344054);
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
