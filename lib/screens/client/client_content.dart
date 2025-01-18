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
          key: ValueKey<String>(
              '${navigation.currentClientScreen}_${navigation.currentClientId ?? ''}'),
          child: _buildContent(navigation),
        );
      },
    );
  }

  Widget _buildContent(NavigationService navigation) {
    switch (navigation.currentClientScreen) {
      case ClientScreen.list:
        return const ClientListContent();
      case ClientScreen.bulkUpload:
        return const ClientBulkUploadContent();
      case ClientScreen.view:
      case ClientScreen.edit:
      case ClientScreen.create:
        return const ClientListContent();
      default:
        return const ClientListContent();
    }
  }
}
