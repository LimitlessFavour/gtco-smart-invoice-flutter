import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import 'app_text.dart';
import 'dart:io';

class ImageUpload extends StatefulWidget {
  final Function(String?) onImageSelected;
  final bool isMobile;
  final String label;
  final Key? imageKey;

  const ImageUpload({
    super.key,
    required this.onImageSelected,
    this.isMobile = true,
    this.label = 'Upload Product Image',
    this.imageKey,
  });

  @override
  State<ImageUpload> createState() => ImageUploadState();
}

class ImageUploadState extends State<ImageUpload> {
  String? _selectedImagePath;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImagePath = pickedFile.path;
        });
        widget.onImageSelected(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void clearImage() {
    setState(() {
      _selectedImagePath = null;
    });
    widget.onImageSelected(null);
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
          onTap: _pickImage,
          child: Container(
            height: 120,
            width: _selectedImagePath != null
                ? 120
                : double.infinity, // Square if image selected
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_selectedImagePath == null)
                  // Empty state
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      const Gap(8),
                      AppText(
                        'Click to upload image',
                        size: 12,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  )
                else
                  // Selected image state with overlay
                  ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: Stack(
                      children: [
                        // Image
                        Image.file(
                          File(_selectedImagePath!),
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                        // Semi-transparent overlay on hover
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Remove button (only shown when image is selected)
                if (_selectedImagePath != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: clearImage,
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
