import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:universal_html/html.dart' as html;
import 'app_text.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class FileUpload extends StatefulWidget {
  final Function(String?) onFileSelected;
  final String label;
  final List<String> allowedExtensions;
  final Key? fileKey;

  const FileUpload({
    super.key,
    required this.onFileSelected,
    this.label = 'Upload File',
    this.allowedExtensions = const ['csv'],
    this.fileKey,
  });

  @override
  State<FileUpload> createState() => FileUploadState();
}

class FileUploadState extends State<FileUpload> {
  String? _selectedFilePath;
  String? _fileName;
  html.File? _webFile;

  Future<void> _pickFile() async {
    try {
      if (kIsWeb) {
        final input = html.FileUploadInputElement()
          ..accept = widget.allowedExtensions.map((e) => '.$e').join(',');
        input.click();

        await input.onChange.first;
        if (input.files?.isNotEmpty ?? false) {
          _webFile = input.files!.first;
          setState(() {
            _fileName = _webFile!.name;
            _selectedFilePath = _webFile!.name;
          });
          widget.onFileSelected(_selectedFilePath);
        }
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: widget.allowedExtensions,
          withData: kIsWeb,
        );

        if (result != null) {
          setState(() {
            _selectedFilePath = result.files.single.path;
            _fileName = result.files.single.name;
          });
          widget.onFileSelected(_selectedFilePath);
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  void clearFile() {
    setState(() {
      _selectedFilePath = null;
      _fileName = null;
      _webFile = null;
    });
    widget.onFileSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          widget.label,
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_selectedFilePath == null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file_outlined,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      const Gap(8),
                      AppText(
                        'Click to upload CSV file',
                        size: 12,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                      const Gap(8),
                      AppText(
                        _fileName ?? 'File selected',
                        size: 12,
                        color: Colors.grey[800]!,
                      ),
                    ],
                  ),
                if (_selectedFilePath != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: clearFile,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xFFE04403),
                        ),
                      ),
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
