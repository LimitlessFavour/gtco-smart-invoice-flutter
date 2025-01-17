import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../providers/client_provider.dart';
import '../common/app_text.dart';

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
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: width * 0.8,
        constraints: BoxConstraints(maxWidth: width * 0.4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF9D9D2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: AppText(
                'Select Client',
                size: 16,
                weight: FontWeight.w600,
                color: theme.primaryColor,
              ),
            ),
            // Content
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search clients...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

                      return Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: provider.clients.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final client = provider.clients[index];
                            return ListTile(
                              title: AppText(client.fullName),
                              subtitle: AppText(
                                client.email,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              onTap: () => Navigator.of(context).pop(client),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: AppText(
                          'Cancel',
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
