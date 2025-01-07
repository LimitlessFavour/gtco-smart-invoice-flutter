import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/custom_scroll_view.dart';
import '../../../widgets/common/app_text.dart';

class InvoicePreview extends StatelessWidget {
  final Color themeColor;
  final ImageProvider? logo;

  const InvoicePreview({
    super.key,
    required this.themeColor,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //APP TEXT CALLED TEMPLATE
        Container(
          margin: const EdgeInsets.only(left: 16, bottom: 16),
          child: const AppText(
            'Template',
            size: 16,
            weight: FontWeight.w600,
          ),
        ),
        const Gap(15),
        Container(
          width: 400,
          height: 600,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.only(left: 16, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CustomScrollWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Section
                SizedBox(
                  height: 60,
                  child: logo != null
                      ? Image(image: logo!, fit: BoxFit.contain)
                      : const Text('BeeDaisy', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: 24),
                // Invoice Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'Invoice #1001',
                          color: themeColor,
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        const AppText('Date: 20/01/2025', size: 14),
                      ],
                    ),
                    const AppText('Due Date: 20/02/2025', size: 14),
                  ],
                ),
                const SizedBox(height: 32),
                // From and To Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText('From:', color: themeColor, size: 14),
                          const SizedBox(height: 8),
                          const AppText('Bee Daisy Hair & Merchaise', size: 14),
                          const AppText('+234 905 691 8846', size: 14),
                          const AppText(
                              '12b Emma Abimbola Cole\nStreet, Lekki phase1',
                              size: 14),
                          const AppText('beedaisyhair@gmail.com', size: 14),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText('To:', color: themeColor, size: 14),
                          const SizedBox(height: 8),
                          const AppText('John Snow', size: 14),
                          const AppText('09056918846', size: 14),
                          const AppText(
                              'No 3 Peaceville Estate,\nBadore, Ajah, Lagos',
                              size: 14),
                          const AppText('johnsnow@gmail.com', size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Table Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: AppText('PRODUCT',
                            color: themeColor, weight: FontWeight.w600),
                      ),
                      Expanded(
                        child: AppText('PRICE',
                            color: themeColor, weight: FontWeight.w600),
                      ),
                      Expanded(
                        child: AppText('QTY',
                            color: themeColor, weight: FontWeight.w600),
                      ),
                      Expanded(
                        child: AppText('TOTAL',
                            color: themeColor, weight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                // Table Content
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: const Row(
                    children: [
                      Expanded(
                          flex: 2, child: AppText('Bone Straight', size: 14)),
                      Expanded(child: AppText('₦200,000', size: 14)),
                      Expanded(child: AppText('1', size: 14)),
                      Expanded(child: AppText('₦200,000.00', size: 14)),
                    ],
                  ),
                ),
                // const Spacer(),
                const Gap(70),
                // Total Section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppText('Sub Total', size: 14),
                          const AppText('₦200,000.00', size: 14),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppText('Discount', size: 14),
                          const AppText('-', size: 14),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppText('VAT', size: 14),
                          const AppText('-', size: 14),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText('Total',
                              size: 16,
                              color: themeColor,
                              weight: FontWeight.w600),
                          const AppText('₦200,000.00',
                              size: 16, weight: FontWeight.w600),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
