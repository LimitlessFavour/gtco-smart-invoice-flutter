import 'package:flutter/material.dart';
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
        try {
          final client = provider.getClientById(clientId!);
          return CreateClientForm(
            onCancel: onCancel,
            client: client,
          );
        } catch (e) {
          return Center(
            child: Text('Client not found: $e'),
          );
        }
      },
    );
  }
}
