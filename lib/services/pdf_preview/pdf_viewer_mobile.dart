import 'dart:io';
import 'package:open_file/open_file.dart';

class PdfViewerService {
  static Future<void> openPDF(dynamic file) async {
    if (file is File) {
      await OpenFile.open(file.path);
    }
  }
}
