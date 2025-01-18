import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gtco_smart_invoice_flutter/services/navigation_service.dart';
import 'package:gtco_smart_invoice_flutter/widgets/common/file_upload.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../models/bulk_upload_state.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/app_text.dart';

class ProductBulkUploadContent extends StatefulWidget {
  const ProductBulkUploadContent({super.key});

  @override
  State<ProductBulkUploadContent> createState() =>
      _ProductBulkUploadContentState();
}

class _ProductBulkUploadContentState extends State<ProductBulkUploadContent> {
  int _currentStep = 0;
  File? _selectedFile;
  final Map<String, String> _columnMapping = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with actions
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          context
                              .read<NavigationService>()
                              .navigateToProductScreen(ProductScreen.list);
                        },
                      ),
                      const Gap(8),
                      const AppText(
                        'Import Products',
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Stepper and Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFC6C1C1)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: _buildStepper(),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: _buildCurrentStep(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStepCircle(1, 'UPLOAD', _currentStep >= 0),
        _buildStepLine(_currentStep >= 1),
        _buildStepCircle(2, 'MAPDATA', _currentStep >= 1),
        _buildStepLine(_currentStep >= 2),
        _buildStepCircle(3, 'IMPORT', _currentStep >= 2),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF00A651) : Colors.grey,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const Gap(4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF00A651) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 1,
        color: isActive ? const Color(0xFF00A651) : Colors.grey,
      ),
    );
  }


  Widget _buildCurrentStep() {
    final provider = context.watch<ProductProvider>();
    final state = provider.bulkUploadState;

    if (_currentStep == 0) {
      return _buildUploadStep();
    } else if (_currentStep == 1) {
      return _buildMappingStep(provider.bulkUploadState.headers ?? []);
    } else {
      return _buildImportStep(state);
    }
  }

  Widget _buildUploadStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Upload CSV File',
          size: 16,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        const AppText(
          'Upload your CSV file containing product information',
          size: 14,
          color: Color(0xFF464646),
        ),
        const Gap(24),
        FileUpload(
          label: 'Click to upload or drag and drop CSV file',
          onFileSelected: (String? path) {
            if (path != null) {
              setState(() {
                _selectedFile = File(path);
              });
              _validateFile();
            }
          },
        ),
      ],
    );
  }

  Widget _buildMappingStep(List<String> headers) {
    final provider = context.watch<ProductProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Match fields from uploaded file',
          size: 16,
          weight: FontWeight.w500,
        ),
        const Gap(8),
        const AppText(
          'Your file has been uploaded, now check that the fields from your file are matched correctly.',
          size: 14,
          color: Color(0xFF464646),
        ),
        const Gap(24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'SmartInvoice Fields',
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                  const Gap(16),
                  ..._buildRequiredFields(headers),
                ],
              ),
            ),
            const Gap(24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Fields in uploaded file',
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                  const Gap(16),
                  if (provider.bulkUploadState.sampleData?.isNotEmpty ?? false)
                    _buildSampleData(
                      provider.bulkUploadState.sampleData!.first,
                    ),
                ],
              ),
            ),
          ],
        ),
        const Gap(24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() => _currentStep = 0);
              },
              child: const Text('Back'),
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: _columnMapping.length >= 4 ? _startUpload : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildRequiredFields(List<String> headers) {
    final requiredFields = [
      'Product Name',
      'Description',
      'Category',
      'Price',
      'VAT category',
    ];

    return requiredFields.map((field) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: AppText(
                field,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            const Gap(16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _columnMapping[field],
                decoration: InputDecoration(
                  hintText: 'Select field',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                items: headers.map((header) {
                  return DropdownMenuItem(
                    value: header,
                    child: Text(header),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _columnMapping[field] = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildImportStep(BulkUploadState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Importing Products',
          size: 16,
          weight: FontWeight.w500,
        ),
        const Gap(24),
        if (state.status == BulkUploadStatus.uploading) ...[
          _buildProgressIndicator(),
        ] else if (state.status == BulkUploadStatus.completed) ...[
          _buildSuccessState(),
        ] else if (state.status == BulkUploadStatus.error) ...[
          _buildErrorState(),
        ],
        const Gap(24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                context
                    .read<NavigationService>()
                    .navigateToProductScreen(ProductScreen.list);
              },
              child: const AppText('Close'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    final provider = context.watch<ProductProvider>();
    final state = provider.bulkUploadState;
    final hasProgress = state.processedRows != null && state.totalRows != null;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(16),
          LinearProgressIndicator(
            value:
                hasProgress ? (state.processedRows! / state.totalRows!) : null,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00A651)),
          ),
          const Gap(16),
          AppText(
            hasProgress
                ? 'Processing ${(state.processedRows! / state.totalRows! * 100).toInt()}% (${state.processedRows}/${state.totalRows} products)'
                : 'Processing...',
            size: 14,
            color: const Color(0xFF464646),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    final provider = context.watch<ProductProvider>();
    final state = provider.bulkUploadState;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(16),
          const Icon(
            Icons.check_circle,
            color: Color(0xFF00A651),
            size: 48,
          ),
          const Gap(16),
          AppText(
            'Successfully imported ${state.successCount} products',
            size: 16,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final provider = context.watch<ProductProvider>();
    final error = provider.bulkUploadState.error;

    return Column(
      children: [
        const Icon(
          Icons.error,
          color: Colors.red,
          size: 48,
        ),
        const Gap(16),
        AppText(
          'Failed to import products',
          size: 16,
          weight: FontWeight.w500,
        ),
        if (error != null) ...[
          const Gap(8),
          AppText(
            error,
            size: 14,
            color: Colors.red,
          ),
        ],
      ],
    );
  }

  Widget _buildSampleData(Map<String, dynamic> sampleRow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Sample Data Preview',
          size: 14,
          weight: FontWeight.w500,
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sampleRow.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: AppText(
                        entry.key,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: AppText(
                        entry.value?.toString() ?? '',
                        size: 14,
                        color: const Color(0xFF464646),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _validateFile() async {
    if (_selectedFile == null) return;

    try {
      final provider = context.read<ProductProvider>();

      if (!_selectedFile!.path.toLowerCase().endsWith('.csv')) {
        throw Exception('Please select a valid CSV file');
      }

      await provider.validateBulkUpload(_selectedFile!);

      if (provider.bulkUploadState.status == BulkUploadStatus.validated) {
        _autoMapColumns(provider.bulkUploadState.headers ?? []);
        setState(() => _currentStep = 1);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startUpload() async {
    try {
      final provider = context.read<ProductProvider>();
      setState(() => _currentStep = 2);
      await provider.startBulkUpload(
        file: _selectedFile!,
        columnMapping: _columnMapping,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _autoMapColumns(List<String> headers) {
    final requiredFields = {
      'Product Name': ['product', 'name', 'product name', 'productname'],
      'Description': ['description', 'desc', 'details'],
      'Category': ['category', 'type', 'product category'],
      'Price': ['price', 'cost', 'amount'],
      'VAT category': ['vat', 'tax', 'vat category', 'vatcategory'],
    };

    requiredFields.forEach((field, matches) {
      for (final header in headers) {
        final headerLower = header.toLowerCase();
        if (matches.any((match) => headerLower.contains(match))) {
          _columnMapping[field] = header;
          break;
        }
      }
    });
  }

  @override
  void dispose() {
    context.read<ProductProvider>().resetBulkUploadState();
    super.dispose();
  }
}
