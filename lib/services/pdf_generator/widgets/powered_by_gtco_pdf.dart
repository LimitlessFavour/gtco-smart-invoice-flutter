import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PoweredByGtcoPdf {
  static pw.Widget build(pw.Font regularFont, pw.Font boldFont) {
    final primaryColor = PdfColor.fromHex('E04403'); // GTCO primary color

    return pw.Center(
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            'Powered by ',
            style: pw.TextStyle(
              font: regularFont,
              color: PdfColors.grey600,
              fontSize: 12,
            ),
          ),
          pw.Text(
            'GTCO ',
            style: pw.TextStyle(
              font: boldFont,
              color: primaryColor,
              fontSize: 12,
            ),
          ),
          pw.Text(
            'Smart Invoice',
            style: pw.TextStyle(
              font: boldFont,
              color: primaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
