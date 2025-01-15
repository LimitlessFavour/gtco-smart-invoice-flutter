import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/screens/product/mobile/product_mobile_form.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';

class CreateProductMobile extends StatelessWidget {
  const CreateProductMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'New Product',
          size: 18,
          weight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Product Details',
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  Gap(16),
                  ProductMobileForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
