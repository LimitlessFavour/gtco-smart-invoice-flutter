import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/services.dart';
import 'package:gtco_smart_invoice_flutter/models/auth/user.dart';
import 'package:gtco_smart_invoice_flutter/models/client.dart';
import 'package:gtco_smart_invoice_flutter/models/company.dart';
import 'package:gtco_smart_invoice_flutter/services/pdf_generator/widgets/naira_text_pdf.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/invoice.dart';
import './pdf_generator/widgets/powered_by_gtco_pdf.dart';
import './pdf_preview/pdf_viewer.dart';

class PdfGeneratorService {
  static Future<String> generateAndSavePdf(User user, Invoice invoice) async {
    final pdf = pw.Document();

    // Load fonts
    final urbanistRegular = await PdfGoogleFonts.urbanistRegular();
    final urbanistBold = await PdfGoogleFonts.urbanistBold();
    final notoSans = await PdfGoogleFonts.notoSansRegular();

    // Load company logo from network
    final Uint8List? logoBytes = await _loadNetworkImage(user.company?.logo);
    final logoImage = logoBytes != null ? pw.MemoryImage(logoBytes) : null;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with Logo and Invoice Number
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    logoImage != null
                        ? pw.Image(logoImage, height: 40)
                        : pw.Container(height: 40),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'INVOICE',
                          style: pw.TextStyle(
                            font: urbanistBold,
                            fontSize: 24,
                          ),
                        ),
                        pw.Text(
                          '#${invoice.invoiceNumber}',
                          style: pw.TextStyle(
                            font: urbanistRegular,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 32),

                // From and Bill To Section
                _buildDesktopInfoSection(
                  invoice.company,
                  user,
                  invoice.client,
                  urbanistRegular,
                  urbanistBold,
                ),
                pw.SizedBox(height: 32),

                // Dates
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateInfo(
                      'Invoice Date',
                      invoice.createdAt.toString().split(' ')[0],
                      urbanistRegular,
                    ),
                    _buildDateInfo(
                      'Due Date',
                      invoice.dueDate.toString().split(' ')[0],
                      urbanistRegular,
                    ),
                  ],
                ),
                pw.SizedBox(height: 32),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 16),

                // Items Table
                _buildItemsTable(
                    invoice, urbanistRegular, urbanistBold, notoSans),
                pw.SizedBox(height: 32),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 16),

                // Totals Section
                _buildTotalSection(
                    invoice, urbanistRegular, urbanistBold, notoSans),
                pw.SizedBox(height: 48),

                // Footer
                PoweredByGtcoPdf.build(urbanistRegular, urbanistBold),
              ],
            ),
          );
        },
      ),
    );

    if (kIsWeb) {
      final bytes = await pdf.save();
      return 'web_invoice_${invoice.invoiceNumber}';
    } else {
      final output = await getTemporaryDirectory();
      final filePath = '${output.path}/invoice_${invoice.invoiceNumber}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      return filePath;
    }
  }

  static Future<Uint8List?> _loadNetworkImage(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint('Error loading network image: $e');
    }
    return null;
  }

  static Future<void> openPdf(String pdfPath) async {
    if (kIsWeb) {
      // For web: open in new tab
      await PdfViewerService.openPDF(pdfPath);
    } else {
      // For mobile: open saved file
      await PdfViewerService.openPDF(File(pdfPath));
    }
  }

  static pw.Widget _buildInfoSection(
    String title,
    String name,
    String details,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            font: regularFont,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          name,
          style: pw.TextStyle(
            font: boldFont,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          details,
          style: pw.TextStyle(
            font: regularFont,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildDateInfo(
    String label,
    String date,
    pw.Font font,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: font,
            color: PdfColors.grey600,
            fontSize: 14,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          date,
          style: pw.TextStyle(
            font: font,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildItemsTable(
    Invoice invoice,
    pw.Font regularFont,
    pw.Font boldFont,
    pw.Font notoSans,
  ) {
    return pw.Column(
      children: [
        _buildTableHeader(regularFont),
        pw.SizedBox(height: 16),
        ...invoice.items.map((item) => pw.Column(
              children: [
                _buildTableRow(
                  item.productName ?? 'Product',
                  item.quantity,
                  item.price,
                  regularFont,
                  notoSans,
                ),
                pw.SizedBox(height: 8),
              ],
            )),
      ],
    );
  }

  static pw.Widget _buildTableHeader(pw.Font font) {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            'Item',
            style: pw.TextStyle(
              font: font,
              color: PdfColors.grey600,
              fontSize: 14,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            'Qty',
            style: pw.TextStyle(
              font: font,
              color: PdfColors.grey600,
              fontSize: 14,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            'Price',
            style: pw.TextStyle(
              font: font,
              color: PdfColors.grey600,
              fontSize: 14,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            'Total',
            style: pw.TextStyle(
              font: font,
              color: PdfColors.grey600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTableRow(
    String item,
    int qty,
    double price,
    pw.Font font,
    pw.Font notoSans,
  ) {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            item,
            style: pw.TextStyle(
              font: font,
              fontSize: 14,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            qty.toString(),
            style: pw.TextStyle(
              font: font,
              fontSize: 14,
            ),
          ),
        ),
        pw.Expanded(
          child: NairaTextPdf.build(
            price.toStringAsFixed(2),
            notoSans,
          ),
        ),
        pw.Expanded(
          child: NairaTextPdf.build(
            (qty * price).toStringAsFixed(2),
            notoSans,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTotalSection(
    Invoice invoice,
    pw.Font regularFont,
    pw.Font boldFont,
    pw.Font notoSans,
  ) {
    final formatter = NumberFormat("#,##0.00", "en_US");

    return pw.Column(
      children: [
        _buildTotalRow(
          'Subtotal',
          formatter.format(invoice.totalAmount),
          regularFont,
          notoSans,
        ),
        pw.SizedBox(height: 8),
        _buildTotalRow(
          'VAT (7.5%)',
          formatter.format(invoice.totalAmount * 0.075),
          regularFont,
          notoSans,
        ),
        pw.SizedBox(height: 8),
        _buildTotalRow(
          'Total',
          formatter.format(invoice.totalAmount * 1.075),
          boldFont,
          notoSans,
          isTotal: true,
        ),
      ],
    );
  }

  static pw.Widget _buildTotalRow(
    String label,
    String amount,
    pw.Font font,
    pw.Font notoSans, {
    bool isTotal = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: font,
            color: isTotal ? PdfColors.black : PdfColors.grey600,
            fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        NairaTextPdf.build(
          amount,
          notoSans,
          isBold: isTotal,
          color: isTotal ? PdfColors.black : PdfColors.grey600,
        ),
      ],
    );
  }

  static pw.Widget _buildDesktopInfoSection(
    Company company,
    User user,
    Client client,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildInfoSection(
          'From',
          company.name,
          '${user.email}\n${user.phoneNumber}',
          regularFont,
          boldFont,
        ),
        _buildInfoSection(
          'Bill To',
          client.fullName,
          '${client.email}\n${client.phoneNumber}\n${client.address}',
          regularFont,
          boldFont,
        ),
      ],
    );
  }
}
