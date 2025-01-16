import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../models/client.dart';
import '../../../widgets/common/app_text.dart';
import '../../../providers/client_provider.dart';
import '../../../widgets/dialogs/confirmation_dialog.dart';
import '../../../widgets/dialogs/success_dialog.dart';
import 'package:provider/provider.dart';

class CurrentClientMobile extends StatelessWidget {
  final Client client;
  final _currencyFormatter = NumberFormat.currency(
    symbol: '₦',
    decimalDigits: 0,
  );

  CurrentClientMobile({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          client.fullName,
          size: 18,
          weight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _handleEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _handleDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Revenue Card
              _buildCard(
                title: 'Revenue Generated',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      _currencyFormatter.format(10000),
                      // _currencyFormatter.format(client.totalRevenue),
                      size: 24,
                      weight: FontWeight.w600,
                      color: const Color(0xFF00A651),
                    ),
                    const Gap(8),
                    AppText(
                      'Total Revenue',
                      size: 14,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // Client Info Card
              _buildCard(
                title: 'Client Information',
                child: Column(
                  children: [
                    _buildInfoRow('Full Name', client.fullName),
                    const Gap(16),
                    _buildInfoRow('Email', client.email),
                    const Gap(16),
                    _buildInfoRow('Phone Number', client.phoneNumber),
                    const Gap(16),
                    _buildInfoRow('Address', client.address),
                  ],
                ),
              ),
              const Gap(16),

              // Recent Invoices
              _buildCard(
                title: 'Recent Invoices',
                child: Column(
                  children: [
                    // Invoice List Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppText(
                              'Invoice ID',
                              size: 12,
                              weight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: AppText(
                              'Amount',
                              size: 12,
                              weight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: AppText(
                              'Status',
                              size: 12,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Invoice List Items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      // itemCount: client.recentInvoices.length,
                      itemBuilder: (context, index) {
                        // final invoice = client.recentInvoices[index];
                        // return _buildInvoiceRow(
                        //   invoice.id,
                        //   invoice.amount,
                        //   invoice.status,
                        // );
                        return _buildInvoiceRow(
                          '123',
                          1000,
                          'paid',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
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
            size: 18,
            weight: FontWeight.w600,
          ),
          const Gap(16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AppText(
            label,
            size: 14,
            color: Colors.grey[600],
          ),
        ),
        const Gap(8),
        Expanded(
          flex: 3,
          child: AppText(
            value,
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceRow(String id, double amount, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              id,
              size: 14,
            ),
          ),
          Expanded(
            flex: 1,
            child: AppText(
              _currencyFormatter.format(amount),
              size: 14,
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildStatusBadge(status),
          ),
        ],
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
      case 'drafted':
        backgroundColor = const Color(0xFFF2F4F7);
        textColor = const Color(0xFF344054);
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        displayText,
        size: 12,
        weight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    // TODO: Implement edit functionality
  }

  void _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const AppConfirmationDialog(
        title: 'Delete Client',
        content:
            'Are you sure you want to delete this client? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel',
      ),
    );

    if (confirmed == true) {
      // TODO: Implement delete functionality
      await context.read<ClientProvider>().deleteClient(client.id);
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => const AppSuccessDialog(
            title: 'Successful!',
            message: 'Client deleted successfully',
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
