import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'app_text.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

class FileUpload extends StatefulWidget {
  final Function(String? path, {PlatformFile? webFile}) onFileSelected;
  final String label;
  final List<String>? allowedExtensions;

  const FileUpload({
    super.key,
    required this.onFileSelected,
    this.label = 'Click to upload or drag and drop file',
    this.allowedExtensions,
  });

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  String? _selectedFileName;
  bool _isDragging = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: widget.allowedExtensions,
        withData: kIsWeb, // Only load data in web
      );

      if (result != null) {
        setState(() {
          _selectedFileName = result.files.first.name;
        });

        if (kIsWeb) {
          widget.onFileSelected(null, webFile: result.files.first);
        } else {
          widget.onFileSelected(result.files.first.path);
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<List<dynamic>>(
      onAccept: (List<dynamic> data) async {
        if (data.isEmpty) return;

        if (kIsWeb) {
          // Handle web drag and drop
          final bytes = data[0] as Uint8List;
          final name = data[1] as String;

          final platformFile = PlatformFile(
            name: name,
            size: bytes.length,
            bytes: bytes,
          );

          setState(() {
            _selectedFileName = name;
            _isDragging = false;
          });

          widget.onFileSelected(null, webFile: platformFile);
        } else {
          // Handle mobile drag and drop
          final path = data[0] as String;
          setState(() {
            _selectedFileName = path.split('/').last;
            _isDragging = false;
          });
          widget.onFileSelected(path);
        }
      },
      onLeave: (data) {
        setState(() => _isDragging = false);
      },
      onWillAccept: (data) {
        setState(() => _isDragging = true);
        return true;
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: _pickFile,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isDragging
                      ? const Color(0xFF00A651)
                      : const Color(0xFFE0E0E0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
                color:
                    _isDragging ? const Color(0xFFF5FFF9) : Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _selectedFileName != null
                        ? Icons.file_present
                        : Icons.cloud_upload_outlined,
                    size: 40,
                    color: _isDragging
                        ? const Color(0xFF00A651)
                        : Colors.grey[400],
                  ),
                  const Gap(8),
                  if (_selectedFileName != null) ...[
                    AppText(
                      _selectedFileName!,
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                    const Gap(4),
                    AppText(
                      'Click to change file',
                      size: 12,
                      color: Colors.grey[600]!,
                    ),
                  ] else
                    AppText(
                      widget.label,
                      size: 14,
                      color: Colors.grey[600]!,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
