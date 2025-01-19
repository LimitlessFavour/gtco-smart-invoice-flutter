import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/models/client.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../providers/client_provider.dart';
import '../../services/navigation_service.dart';
import 'create_client_form.dart';

class ClientFormContainer extends StatelessWidget {
  final VoidCallback onCancel;
  final String? clientId;

  const ClientFormContainer({
    super.key,
    required this.onCancel,
    this.clientId,
  });

  @override
  Widget build(BuildContext context) {
    if (clientId == null) {
      return CreateClientForm(onCancel: onCancel);
    }

    return Consumer<ClientProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<Client?>(
          future: provider.getClientById(clientId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CommonProgressIndicator(size: 30);
            }
            if (snapshot.hasError) {
              return Center(
                child: AppText(
                  'Error loading client: ${snapshot.error}',
                  color: Colors.red,
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: AppText(
                  'Client not found',
                  color: Colors.red,
                ),
              );
            }
            return CreateClientForm(
              onCancel: onCancel,
              clientId: clientId,
            );
          },
        );
      },
    );
  }
}
