import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class NairaTextPdf {
  static pw.Widget build(
    String amount,
    pw.Font font, {
    bool isBold = false,
    PdfColor? color,
  }) {

    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '₦',
            style: pw.TextStyle(
              font: font,
              color: color,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.TextSpan(
            text: amount,
            style: pw.TextStyle(
              font: font,
              color: color,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
