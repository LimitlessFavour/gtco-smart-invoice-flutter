import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/client_provider.dart';
import '../../services/navigation_service.dart';

class ClientListView extends StatelessWidget {
  const ClientListView({super.key});

  void _handleClientTap(BuildContext context, String clientId) {
    // Schedule the navigation for the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<NavigationService>()
          .navigateToClientScreen(ClientScreen.view, clientId: clientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await provider.loadClients();
          },
          child: ListView.builder(
            itemCount: provider.clients.length,
            itemBuilder: (context, index) {
              final client = provider.clients[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () => _handleClientTap(context, client.id),
                  title: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(client.fullName),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(client.email),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(client.phoneNumber),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(client.address),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
