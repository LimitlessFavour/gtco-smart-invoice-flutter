import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/client/mobile/client_mobile_card.dart';
import 'package:provider/provider.dart';
import '../../../providers/client_provider.dart';
import '../../../widgets/common/app_text.dart';
import '../../../widgets/common/loading_overlay.dart';
import '../../../widgets/client/client_empty_state.dart';
import 'create_client_mobile.dart';

class ClientMobile extends StatelessWidget {
  const ClientMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, provider, child) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: Scaffold(
            body: Column(
              children: [
                // Search Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search clients...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                // Client List
                Expanded(
                  child: provider.clients.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.clients.length,
                          separatorBuilder: (context, index) => const Gap(16),
                          itemBuilder: (context, index) {
                            final client = provider.clients[index];
                            return ClientMobileCard(client: client);
                          },
                        )
                      : const ClientEmptyState(isMobile: true),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateClientMobile(),
                  ),
                );
              },
              backgroundColor: const Color(0xFFE04403),
              label: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white),
                  Gap(4),
                  AppText(
                    'New Client',
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
