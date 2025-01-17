import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/providers/client_provider.dart';
import 'package:gtco_smart_invoice_flutter/screens/client/client_bulk_upload_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/client/client_list_content.dart';
import 'package:provider/provider.dart';

import '../../services/navigation_service.dart';


class ClientContent extends StatelessWidget {
  const ClientContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationService, ClientProvider>(
      builder: (context, navigation, clientProvider, _) {
        return KeyedSubtree(
          key: ValueKey<String>('${navigation.currentInvoiceScreen}_${navigation.currentInvoiceId ?? ''}'),
          child: _buildContent(navigation, clientProvider),
        );
      },
    );
  }

  Widget _buildContent(NavigationService navigation, ClientProvider clientProvider) {
    switch (navigation.currentClientScreen) {
      case ClientScreen.list:
        return const ClientListContent();
      case ClientScreen.bulkUpload:
        return const ClientBulkUploadContent();
      default:
        // Fallback to list if no invoice ID
      navigation.navigateToClientScreen(ClientScreen.list);
      return const ClientListContent();
    }
  }
} 