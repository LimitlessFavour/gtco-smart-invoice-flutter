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
          key: ValueKey<String>('${navigation.currentInvoiceScreen}_${navigation.currentInvoiceId ?? ''}'),
          child: _buildContent(navigation, productProvider),
        );
      },
    );
  }

  Widget _buildContent(NavigationService navigation, ProductProvider productProvider) {
    switch (navigation.currentProductScreen) {
      case ProductScreen.list:
        return const ProductListContent();
      case ProductScreen.bulkUpload:
        return const ProductBulkUploadContent();
      default:
        // Fallback to list if no invoice ID
      navigation.navigateToProductScreen(ProductScreen.list);
      return const ProductListContent();
    }
  }
} 