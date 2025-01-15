import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../common/app_text.dart';
import '../common/loading_overlay.dart';

class ClientSelectionDialog extends StatefulWidget {
  const ClientSelectionDialog({super.key});

  @override
  State<ClientSelectionDialog> createState() => _ClientSelectionDialogState();
}

class _ClientSelectionDialogState extends State<ClientSelectionDialog> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load clients when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientProvider>().loadClients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Select Client',
              size: 20,
              weight: FontWeight.w600,
            ),
            const Gap(16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search clients...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<ClientProvider>().searchClients(value);
              },
            ),
            const Gap(16),
            Consumer<ClientProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                    child: AppText(
                      provider.error!,
                      color: Colors.red,
                    ),
                  );
                }

                if (!provider.hasClients) {
                  return const Center(
                    child: AppText('No clients found'),
                  );
                }

                return SizedBox(
                  height: 300,
                  child: ListView.separated(
                    itemCount: provider.clients.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final client = provider.clients[index];
                      return ListTile(
                        title: AppText(client.fullName),
                        subtitle: AppText(
                          client.email,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        onTap: () {
                          Navigator.of(context).pop(client);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
