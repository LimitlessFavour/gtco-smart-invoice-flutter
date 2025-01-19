import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/widgets/dashboard/activity_card.dart';
import '../models/dashboard_analytics.dart';

class ActivityMapper {
  static ActivityItem mapToActivityItem(DashboardActivity activity) {
    switch (activity.activity) {
      case 'INVOICE_CREATED':
        return ActivityItem(
          icon: Icons.receipt,
          color: const Color(0xFFE04403),
          title: 'Invoice Generated',
          description: _getInvoiceCreatedDescription(activity.metadata),
          time: _getTimeFromDate(activity.date),
          date: _getFormattedDate(activity.date),
        );

      case 'PAYMENT_RECEIVED':
        return ActivityItem(
          icon: Icons.payments_outlined,
          color: Colors.green,
          title: 'Payment Received',
          description: _getPaymentReceivedDescription(activity.metadata),
          time: _getTimeFromDate(activity.date),
          date: _getFormattedDate(activity.date),
        );

      case 'CLIENT_CREATED':
        return ActivityItem(
          icon: Icons.person_add_outlined,
          color: Colors.blue,
          title: 'Client Added',
          description: _getClientCreatedDescription(activity.metadata),
          time: _getTimeFromDate(activity.date),
          date: _getFormattedDate(activity.date),
        );

      case 'PRODUCT_CREATED':
        return ActivityItem(
          icon: Icons.inventory_2_outlined,
          color: Colors.purple,
          title: 'Product Created',
          description: 'A new product has been added to your catalog',
          time: _getTimeFromDate(activity.date),
          date: _getFormattedDate(activity.date),
        );

      default:
        return ActivityItem(
          icon: Icons.info_outline,
          color: Colors.grey,
          title: activity.activity.replaceAll('_', ' ').toLowerCase(),
          description: 'Activity recorded',
          time: _getTimeFromDate(activity.date),
          date: _getFormattedDate(activity.date),
        );
    }
  }

  static String _getInvoiceCreatedDescription(Map<String, dynamic>? metadata) {
    if (metadata == null) return 'New invoice has been generated';
    return 'Invoice #${metadata['invoiceNumber']} of amount ₦${_formatAmount(metadata['amount'])} has been generated';
  }

  static String _getPaymentReceivedDescription(Map<String, dynamic>? metadata) {
    if (metadata == null) return 'Payment received for invoice';
    return 'Payment of ₦${_formatAmount(metadata['amount'])} received via ${metadata['paymentType']?.toLowerCase() ?? 'payment gateway'}';
  }

  static String _getClientCreatedDescription(Map<String, dynamic>? metadata) {
    if (metadata == null) return 'New client has been added';
    return '${metadata['name']} has been added as a new client';
  }

  static String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  static String _getTimeFromDate(String dateStr) {
    try {
      // Handle format: "Jan 18, 2025 13:36"
      final parts = dateStr.split(' ');
      if (parts.length >= 4) {
        return parts[3]; // Returns the time part
      }
      return '00:00';
    } catch (e) {
      return '00:00';
    }
  }

  static String _getFormattedDate(String dateStr) {
    try {
      // Handle format: "Jan 18, 2025 13:36"
      final parts = dateStr.split(' ');
      if (parts.length >= 3) {
        return '${parts[1].replaceAll(',', '')}-${parts[0]}-${parts[2]}';
      }
      return DateTime.now().toString();
    } catch (e) {
      return DateTime.now().toString();
    }
  }
}
