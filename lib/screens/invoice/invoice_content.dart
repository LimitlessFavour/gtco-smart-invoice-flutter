import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/navigation_service.dart';
import '../../providers/invoice_provider.dart';
import 'invoice_list_content.dart';
import 'create_invoice_content.dart';
import 'current_invoice_content.dart';

class InvoiceContent extends StatelessWidget {
  const InvoiceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationService, InvoiceProvider>(
      builder: (context, navigation, invoiceProvider, _) {
        return KeyedSubtree(
          key: ValueKey<String>('${navigation.currentInvoiceScreen}_${navigation.currentInvoiceId ?? ''}'),
          child: _buildContent(navigation, invoiceProvider),
        );
      },
    );
  }

  Widget _buildContent(NavigationService navigation, InvoiceProvider invoiceProvider) {
    switch (navigation.currentInvoiceScreen) {
      case InvoiceScreen.list:
        return const InvoiceListContent();
      case InvoiceScreen.create:
        return const CreateInvoiceContent();
      case InvoiceScreen.view:
        if (navigation.currentInvoiceId != null) {
          final invoice = invoiceProvider.invoices.firstWhere(
            (inv) => inv.id.toString() == navigation.currentInvoiceId,
            orElse: () {
              // If invoice not found, navigate back to list
              navigation.navigateToInvoiceScreen(InvoiceScreen.list);
              return invoiceProvider.invoices.first; // This return won't be used
            },
          );
          return CurrentInvoiceContent(invoice: invoice);
        }
        // Fallback to list if no invoice ID
        navigation.navigateToInvoiceScreen(InvoiceScreen.list);
        return const InvoiceListContent();
    }
  }
} 