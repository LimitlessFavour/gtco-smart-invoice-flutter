import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../services/navigation_service.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () {
                  context.read<NavigationService>().navigateToProductScreen(
                        ProductScreen.edit,
                        productId: product.id,
                      );
                },
                title: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(product.productName),
                    ),
                    Expanded(
                      child: Text('₦${product.price}'),
                    ),
                    Expanded(
                      child: Text(product.quantity.toString()),
                    ),
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => context
                                .read<NavigationService>()
                                .navigateToProductScreen(
                                  ProductScreen.edit,
                                  productId: product.id,
                                ),
                            color: const Color(0xFF667085),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              // TODO: Handle delete
                            },
                            color: const Color(0xFF667085),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
