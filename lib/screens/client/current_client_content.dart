import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/client/client_back_button.dart';
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
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            minHeight: 900), // Minimum height for iPad landscape
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ClientsBackButton(),
                      const Gap(16),
                      AppText(
                        client.fullName,
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<String>(
                        offset: const Offset(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        color: Colors.white,
                        elevation: 4,
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  'More Actions',
                                  size: 14,
                                  weight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                                const Gap(8),
                                Icon(Icons.keyboard_arrow_down,
                                    size: 20, color: Colors.grey[800]),
                              ],
                            ),
                          ),
                        ),
                        itemBuilder: (context) => ['Edit', 'Delete']
                            .map(
                              (option) => PopupMenuItem<String>(
                                value: option,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: AppText(
                                    option,
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onSelected: (value) {
                          if (value == 'Edit') {
                            _handleEdit(context);
                          } else {
                            _handleDelete(context);
                          }
                        },
                      ),
                      const Gap(32),
                      InkWell(
                        onTap: () {
                          context
                              .read<NavigationService>()
                              .navigateToClientScreen(ClientScreen.create);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE04403),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                'New Client',
                                color: Colors.white,
                                weight: FontWeight.w500,
                              ),
                              Gap(4),
                              Icon(Icons.add, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Gap(32),
              const Divider(),
              const Gap(32),
              // Content Row
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Revenue Generated Section
                    Expanded(
                      flex: 2,
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
                            const AppText(
                              'Revenue Generated',
                              size: 18,
                              weight: FontWeight.w600,
                            ),
                            const Gap(24),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFFC6C1C1)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.warning_amber_rounded,
                                                color: Colors.grey[600],
                                                size: 20),
                                            const Gap(8),
                                            AppText(
                                              'Overdue amount',
                                              color: Colors.grey[600],
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                        const Gap(8),
                                        AppText(
                                          _currencyFormatter.format(
                                              client.totalOverdueAmount),
                                          size: 16,
                                          weight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFFC6C1C1)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.description_outlined,
                                                color: Colors.grey[600],
                                                size: 20),
                                            const Gap(8),
                                            AppText(
                                              'Drafted total',
                                              color: Colors.grey[600],
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                        const Gap(8),
                                        AppText(
                                          _currencyFormatter.format(
                                              client.totalDraftedAmount),
                                          size: 16,
                                          weight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFFC6C1C1)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.refresh,
                                                color: Colors.grey[600],
                                                size: 20),
                                            const Gap(8),
                                            AppText(
                                              'Updated total',
                                              color: Colors.grey[600],
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                        const Gap(8),
                                        AppText(
                                          _currencyFormatter
                                              .format(client.totalPaidAmount),
                                          size: 16,
                                          weight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(24),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const AppText(
                                      'No of Invoices sent:',
                                      size: 14,
                                      color: Color(0xFF464646),
                                    ),
                                    const Gap(16),
                                    const AppText(
                                      'No of Invoices drafted:',
                                      size: 14,
                                      color: Color(0xFF464646),
                                    ),
                                  ],
                                ),
                                const Gap(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      client.totalInvoicesSent.toString(),
                                      size: 14,
                                    ),
                                    const Gap(16),
                                    AppText(
                                      client.totalInvoicesDrafted.toString(),
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(24),
                    // Client Details Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFC6C1C1)),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            border: Border.all(color: const Color(0xFFC6C1C1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                client.fullName,
                                size: 16,
                                weight: FontWeight.w700,
                              ),
                              const Gap(24),
                              _buildDetailRow('call', client.phoneNumber),
                              const Gap(16),
                              _buildDetailRow('mail', client.email),
                              const Gap(16),
                              _buildDetailRow('location', client.address),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(32),
              // Invoices Section
              Container(
                height: 400, // Fixed height for invoice section
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC6C1C1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          'Invoices for ${client.fullName}',
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                        const Gap(12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE04403),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: AppText(
                            client.totalInvoicesSent.toString(),
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
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
                        children: client.invoices.map((invoice) {
                          return _buildInvoiceRow(
                            invoice.invoiceNumber,
                            client.fullName,
                            DateFormat('dd.MM.yyyy').format(invoice.createdAt),
                            invoice.totalAmount,
                            invoice.status,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(32), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String icon, String value) {
    final path = 'assets/icons/$icon.svg';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          path,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            Colors.black,
            BlendMode.srcIn,
          ),
        ),
        const Gap(21),
        Expanded(child: AppText(value)),
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

  Widget _buildInvoiceRow(
    String id,
    String customer,
    String date,
    double amount,
    String status,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
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
