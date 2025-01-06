import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/slide_panel.dart';
import '../../widgets/common/app_text.dart';
import '../../widgets/client/client_empty_state.dart';
import '../../widgets/client/create_client_form.dart';
import '../../services/navigation_service.dart';
import 'package:provider/provider.dart';

class ClientContent extends StatelessWidget {
  const ClientContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationService>(
      builder: (context, navigation, _) {
        return Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        'Clients',
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                      CreateClientButton(),
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
                      child: const Column(
                        children: [
                          // Search and Filter Row
                          ClientSearchRow(),
                          Gap(24),
                          // Table Header
                          ClientTableHeader(),
                          Gap(24),
                          // Empty State
                          Expanded(child: ClientEmptyState()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Slide Panel
            SlidePanel(
              isOpen: navigation.currentClientScreen == ClientScreen.create,
              onClose: () {
                context
                    .read<NavigationService>()
                    .navigateToClientScreen(ClientScreen.list);
              },
              child: CreateClientForm(
                onCancel: () {
                  context
                      .read<NavigationService>()
                      .navigateToClientScreen(ClientScreen.list);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CreateClientButton extends StatelessWidget {
  const CreateClientButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<NavigationService>().navigateToClientScreen(ClientScreen.create);
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
            ),
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            // TODO: Handle import file
          },
          icon: const Text(
            'Import a file',
            style: TextStyle(
              color: Color(0xFF00A651),
              fontWeight: FontWeight.w500,
            ),
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
