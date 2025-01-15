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
    // if (clientId == null) {
    return CreateClientForm(
      onCancel: onCancel,
      clientId: clientId,
    );
    // }

    // return Consumer<ClientProvider>(
    //   builder: (context, provider, child) {
    //     try {
    //       final client = provider.getClientById(clientId!);
    //       return FutureBuilder<Client?>(
    //           future: client,
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return const CommonProgressIndicator(size: 30);
    //             }
    //             if (snapshot.hasError) {
    //               return const Center(
    //                 child: AppText(
    //                   'An error has occurred',
    //                 ),
    //               );
    //             }
    //             return CreateClientForm(
    //               onCancel: onCancel,
    //               client: snapshot.data!,
    //             );
    //           });
    //     } catch (e) {
    //       return Center(
    //         child: Text('Client not found: $e'),
    //       );
    //     }
    //   },
    // );
  }
}
