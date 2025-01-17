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
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE04826),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const AppText(
                      'New Client',
                      size: 16,
                      weight: FontWeight.w600,
                      color: Colors.white,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Content (Revenue + Contect Details)
                Row(
                  children: [
                    // Revenue Generated Section
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
                            const AppText(
                              'Revenue Generated',
                              size: 22,
                              weight: FontWeight.w600,
                            ),
                            const Gap(24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            const Gap(18),
                            const Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      'No of Invoices sent:',
                                      color: Colors.black,
                                    ),
                                    Gap(8),
                                    AppText(
                                      'No of Invoices drafted:',
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                Gap(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText('1'),
                                    Gap(8),
                                    AppText('0'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(24),
                    // Client Details Card (right side)
                    SizedBox(
                      width: width * 0.3,
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
                              const AppText(
                                'John Snow',
                                size: 18,
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
                const Gap(32),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppText(
                              'Invoices for John Snow',
                              size: 18,
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
                const Gap(32),
              ],
            ),
          ),
        ],
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

  Widget _buildRevenueCard({
    required double amount,
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
          // horizontal: 34,
          vertical: 28,
        ),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xffC6C1C1))),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: const Color(0xFF464646),
                size: 20,
              ),
              const Gap(6),
              AppText(
                _currencyFormatter.format(amount),
                size: 16,
                weight: FontWeight.w600,
              ),
              const Gap(6),
              AppText(
                label,
                size: 12,
                color: const Color(0xFF464646),
              ),
            ],
          ),
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
