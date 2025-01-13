import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/client.dart';
import '../models/invoice.dart';
import '../providers/invoice_provider.dart';
import '../widgets/dialogs/basic_confirmation_dialog.dart';
import '../widgets/dialogs/success_dialog.dart';

mixin InvoiceActions {
  void showSendConfirmation(
    BuildContext context, {
    String? clientName,
    required void Function(BuildContext) onSuccess,
  }) {
    final invoiceProvider = context.read<InvoiceProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) => BasicConfirmationDialog(
        title: 'Confirm Send',
        message:
            'Are you sure you want to send the invoice to ${clientName ?? 'this client'}?',
        confirmText: 'Send',
        onConfirm: () async {
          // Navigator.pop(dialogContext); // Close confirmation dialog


          final success = await invoiceProvider.sendInvoice(
            Invoice(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              companyId: '1',
              clientId: '1',
              invoiceNumber: 'INV-${DateTime.now().millisecondsSinceEpoch}',
              dueDate: DateTime.now().add(const Duration(days: 30)),
              status: 'unpaid',
              totalAmount: 1500.0,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              items: [],
              client: Client(
                id: '1',
                companyId: '1',
                firstName: 'John',
                lastName: 'Snow',
                email: 'john@example.com',
                phoneNumber: '1234567890',
                address: '123 Street',
              ),
            ),
          );

          if (success && context.mounted) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (successContext) => const SuccessDialog(
                message: 'Invoice sent successfully',
              ),
            );

            if (context.mounted) {
              onSuccess(context);
            }
          }
        },
      ),
    );
  }
}
