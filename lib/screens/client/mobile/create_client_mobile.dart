import 'package:flutter/material.dart';
import 'package:gtco_smart_invoice_flutter/screens/client/mobile/client_mobile_form.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/app_text.dart';

class CreateClientMobile extends StatelessWidget {
  const CreateClientMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'New Client',
          size: 18,
          weight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
              child: const ClientMobileForm(),
            ),
          ],
        ),
      ),
    );
  }
}
