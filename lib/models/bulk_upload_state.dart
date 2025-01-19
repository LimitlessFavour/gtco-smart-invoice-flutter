enum BulkUploadStatus {
  initial,
  validating,
  validated,
  uploading,
  completed,
  error,
}

class BulkUploadState {
  final BulkUploadStatus status;
  final String? jobId;
  final Map<String, String>? columnMapping;
  final List<Map<String, dynamic>>? sampleData;
  final List<String>? headers;
  final String? error;
  final int? progress;
  final int? totalRows;
  final int? processedRows;
  final int? successCount;
  final int? errorCount;

  BulkUploadState({
    this.status = BulkUploadStatus.initial,
    this.jobId,
    this.columnMapping,
    this.sampleData,
    this.headers,
    this.error,
    this.progress,
    this.totalRows,
    this.processedRows,
    this.successCount,
    this.errorCount,
  });

  BulkUploadState copyWith({
    BulkUploadStatus? status,
    String? jobId,
    Map<String, String>? columnMapping,
    List<Map<String, dynamic>>? sampleData,
    List<String>? headers,
    String? error,
    int? progress,
    int? totalRows,
    int? processedRows,
    int? successCount,
    int? errorCount,
  }) {
    return BulkUploadState(
      status: status ?? this.status,
      jobId: jobId ?? this.jobId,
      columnMapping: columnMapping ?? this.columnMapping,
      sampleData: sampleData ?? this.sampleData,
      headers: headers ?? this.headers,
      error: error ?? this.error,
      progress: progress ?? this.progress,
      totalRows: totalRows ?? this.totalRows,
      processedRows: processedRows ?? this.processedRows,
      successCount: successCount ?? this.successCount,
      errorCount: errorCount ?? this.errorCount,
    );
  }
}
