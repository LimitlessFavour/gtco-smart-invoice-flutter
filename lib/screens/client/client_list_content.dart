import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/models/client.dart';
import 'package:gtco_smart_invoice_flutter/screens/client/current_client_content.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/loading_overlay.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/client/client_empty_state.dart';
import '../../widgets/client/client_list_view.dart';
import '../../services/navigation_service.dart';
import '../../providers/client_provider.dart';
import 'package:provider/provider.dart';

class ClientListContent extends StatelessWidget {
  const ClientListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationService, ClientProvider>(
      builder: (context, navigation, clientProvider, _) {
        if (navigation.currentClientScreen == ClientScreen.view &&
            navigation.currentClientId != null) {
          return FutureBuilder<Client?>(
            future: clientProvider.getClientById(navigation.currentClientId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CommonProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: AppText(snapshot.error.toString()));
              }
              if (snapshot.hasData) {
                return CurrentClientContent(client: snapshot.data!);
              }
              return EmptyOrErrorState(navigation: navigation);
            },
          );
        }

        // Show client list by default
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      clientProvider.loadClients();
                    },
                    child: const AppText(
                      'Clients',
                      size: 24,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const CreateClientButton(),
                ],
              ),
              const Gap(24),

              // Main Content
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFC6C1C1)),
                  ),
                  child: Column(
                    children: [
                      const ClientSearchRow(),
                      const Gap(24),
                      const ClientTableHeader(),
                      const Gap(24),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await clientProvider.loadClients();
                          },
                          child: clientProvider.hasClients
                              ? const ClientListView()
                              : const ClientEmptyState(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EmptyOrErrorState extends StatelessWidget {
  const EmptyOrErrorState({
    super.key,
    required this.navigation,
  });

  final NavigationService navigation;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppText('Client not found'),
          const Gap(16),
          TextButton(
            onPressed: () =>
                navigation.navigateToClientScreen(ClientScreen.list),
            child: const AppText('Back to Clients'),
          ),
        ],
      ),
    );
  }
}

class CreateClientButton extends StatelessWidget {
  const CreateClientButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<NavigationService>()
            .navigateToClientScreen(ClientScreen.create);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE04403),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              'New Client',
              color: Colors.white,
              weight: FontWeight.w500,
            ),
            Gap(4),
            Icon(Icons.add, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class ClientTableHeader extends StatelessWidget {
  const ClientTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE04403),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              'Name',
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              'Email',
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              'Phone Number',
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              'Address',
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ClientSearchRow extends StatelessWidget {
  const ClientSearchRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Field
        SizedBox(
          width: 252,
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Client',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onChanged: (value) {
                context.read<ClientProvider>().searchClients(value);
              },
            ),
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            print('Navigating to client bulk upload');
            final navigation = context.read<NavigationService>();
            navigation.navigateToClientScreen(ClientScreen.bulkUpload);
          },
          icon: const AppText(
            'Import a file',
            color: Color(0xFF00A651),
            weight: FontWeight.w500,
          ),
          label: const Icon(
            Icons.file_upload_outlined,
            color: Color(0xFF00A651),
          ),
        ),
      ],
    );
  }
}
