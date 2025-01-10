import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static void debug(String message, [Object? data]) {
    if (kDebugMode) {
      _logger.d('💡 DEBUG: $message${data != null ? '\nData: $data' : ''}');
    }
  }

  static void info(String message, [Object? data]) {
    _logger.i('ℹ️ INFO: $message${data != null ? '\nData: $data' : ''}');
  }

  static void warning(String message, [Object? data]) {
    _logger.w('⚠️ WARNING: $message${data != null ? '\nData: $data' : ''}');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(
      '❌ ERROR: $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void success(String message, [Object? data]) {
    _logger.i('✅ SUCCESS: $message${data != null ? '\nData: $data' : ''}');
  }

  static void auth(String message, [Object? data]) {
    _logger.i('🔐 AUTH: $message${data != null ? '\nData: $data' : ''}');
  }
}
