import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/client.dart';
import '../../widgets/common/app_text.dart';
import '../../services/navigation_service.dart';
import '../../providers/client_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/dialogs/confirmation_dialog.dart';
import '../../widgets/dialogs/success_dialog.dart';
import 'package:intl/intl.dart';

class CurrentClientContent extends StatelessWidget {
  final Client client;
  final _currencyFormatter = NumberFormat.currency(
    symbol: '₦',
    decimalDigits: 0,
  );

  CurrentClientContent({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC6C1C1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context
                          .read<NavigationService>()
                          .navigateToClientScreen(ClientScreen.list),
                    ),
                    const Gap(16),
                    AppText(
                      client.fullName,
                      size: 24,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _handleEdit(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    const Gap(16),
                    TextButton.icon(
                      onPressed: () => _handleDelete(context),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(24),
          // Content Row
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Content (Revenue + Invoices)
                Expanded(
                  child: Column(
                    children: [
                      // Revenue Generated Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFC6C1C1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              'Revenue Generated',
                              size: 18,
                              weight: FontWeight.w600,
                            ),
                            const Gap(24),
                            Row(
                              children: [
                                _buildRevenueCard(
                                  amount: 0,
                                  label: 'Overdue amount',
                                  icon: Icons.warning_amber_rounded,
                                ),
                                const Gap(24),
                                _buildRevenueCard(
                                  amount: 0,
                                  label: 'Drafted total',
                                  icon: Icons.description_outlined,
                                ),
                                const Gap(24),
                                _buildRevenueCard(
                                  amount: 200000,
                                  label: 'Updated total',
                                  icon: Icons.update_rounded,
                                ),
                              ],
                            ),
                            const Gap(16),
                            const Divider(),
                            const Gap(16),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppText(
                                      'No of Invoices sent:',
                                      color: Color(0xFF464646),
                                    ),
                                    const Gap(8),
                                    const AppText(
                                      'No of Invoices drafted:',
                                      color: Color(0xFF464646),
                                    ),
                                  ],
                                ),
                                const Gap(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppText('1'),
                                    const Gap(8),
                                    const AppText('0'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),
                      // Invoices Section
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFC6C1C1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const AppText(
                                    'Invoices for John Snow',
                                    size: 18,
                                    weight: FontWeight.w600,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE04403),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const AppText(
                                      '2',
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(24),
                              // Invoice Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE04403),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: AppText(
                                        'INVOICE ID',
                                        color: Colors.white,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AppText(
                                        'CUSTOMER',
                                        color: Colors.white,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AppText(
                                        'DATE',
                                        color: Colors.white,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AppText(
                                        'AMOUNT',
                                        color: Colors.white,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AppText(
                                        'STATUS',
                                        color: Colors.white,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),
                              // Invoice List
                              Expanded(
                                child: ListView(
                                  children: [
                                    _buildInvoiceRow(
                                      '#12345',
                                      'John Snow',
                                      '12.03.2024',
                                      80000,
                                      'Paid',
                                    ),
                                    _buildInvoiceRow(
                                      '#12345',
                                      'John Snow',
                                      '12.03.2024',
                                      80000,
                                      'Drafted',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                // Client Details Card (right side)
                SizedBox(
                  width: 300,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFC6C1C1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppText(
                          'John Snow',
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                        const Gap(24),
                        _buildDetailRow('Phone Number', client.phoneNumber),
                        const Gap(16),
                        _buildDetailRow('Email', client.email),
                        const Gap(16),
                        _buildDetailRow('Address', client.address),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: AppText(
            label,
            weight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: AppText(value),
        ),
      ],
    );
  }

  void _handleEdit(BuildContext context) {
    context
        .read<NavigationService>()
        .navigateToClientScreen(ClientScreen.edit, clientId: client.id);
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Delete Client',
        content: 'Are you sure you want to delete ${client.fullName}?',
        confirmText: 'Delete',
        cancelText: 'Cancel',
      ),
    );

    if (confirmed == true && context.mounted) {
      // Schedule the delete operation for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final success =
            await context.read<ClientProvider>().deleteClient(client.id);

        if (success && context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => const AppSuccessDialog(
              title: 'Successful!',
              message: 'Client deleted successfully',
            ),
          );

          if (context.mounted) {
            context
                .read<NavigationService>()
                .navigateToClientScreen(ClientScreen.list);
          }
        }
      });
    }
  }

  Widget _buildRevenueCard({
    required double amount,
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF464646),
                size: 20,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    _currencyFormatter.format(amount),
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  const Gap(4),
                  AppText(
                    label,
                    size: 12,
                    color: const Color(0xFF464646),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(
    String id,
    String customer,
    String date,
    double amount,
    String status,
  ) {
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
            child: AppText(id),
          ),
          Expanded(
            flex: 2,
            child: AppText(customer),
          ),
          Expanded(
            flex: 2,
            child: AppText(date),
          ),
          Expanded(
            flex: 2,
            child: AppText('₦${NumberFormat('#,###').format(amount)}'),
          ),
          Expanded(
            flex: 2,
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
