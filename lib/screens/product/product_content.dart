import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/providers/product_provider.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/product_bulk_upload_content.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/product_list_content.dart';
import 'package:provider/provider.dart';

import '../../services/navigation_service.dart';

class ProductContent extends StatelessWidget {
  const ProductContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationService, ProductProvider>(
      builder: (context, navigation, productProvider, _) {
        return KeyedSubtree(
          key: ValueKey<String>(
              '${navigation.currentProductScreen}_${navigation.currentProductId ?? ''}'),
          child: _buildContent(navigation),
        );
      },
    );
  }

  Widget _buildContent(NavigationService navigation) {
    switch (navigation.currentProductScreen) {
      case ProductScreen.list:
      case ProductScreen.create:
      case ProductScreen.edit:
        return const ProductListContent();
      case ProductScreen.bulkUpload:
        return const ProductBulkUploadContent();
      default:
        navigation.navigateToProductScreen(ProductScreen.list);
        return const ProductListContent();
    }
  }
}
