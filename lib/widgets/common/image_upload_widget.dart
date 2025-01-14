import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import 'app_text.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(String) onImageSelected;
  final bool isMobile;

  const ImageUploadWidget({
    super.key,
    required this.onImageSelected,
    this.isMobile = true,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  String? _selectedImagePath;

  void _removeSelectedImage() {
    setState(() {
      _selectedImagePath = null;
    });
    widget.onImageSelected(''); // Notify parent that image was removed
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
      widget.onImageSelected(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedImagePath != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              _selectedImagePath!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(8),
        ],
        ElevatedButton.icon(
          onPressed:
              _selectedImagePath == null ? _pickImage : _removeSelectedImage,
          icon: Icon(
              _selectedImagePath == null ? Icons.photo_library : Icons.delete),
          label: AppText(_selectedImagePath == null
              ? 'Choose from Gallery'
              : 'Remove Selected Image'),
        ),
      ],
    );
  }
}
