import 'dart:html' as html;

class PdfViewerService {
  static Future<void> openPDF(dynamic bytes) async {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    html.Url.revokeObjectUrl(url);
  }
}
