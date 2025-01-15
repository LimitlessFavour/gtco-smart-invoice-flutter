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

  static String _formatMessage(String message, [Map<String, dynamic>? data]) {
    if (data == null) return message;
    final buffer = StringBuffer(message);
    buffer.write('\n');
    data.forEach((key, value) {
      buffer.write('  $key: $value\n');
    });
    return buffer.toString();
  }

  static void debug(String message, [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      _logger.d('💡 DEBUG: ${_formatMessage(message, data)}');
    }
  }

  static void info(String message, [Map<String, dynamic>? data]) {
    _logger.i('ℹ️ INFO: ${_formatMessage(message, data)}');
  }

  static void warning(String message, [Map<String, dynamic>? data]) {
    _logger.w('⚠️ WARNING: ${_formatMessage(message, data)}');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    final errorMessage = error != null ? '\nError: $error' : '';
    _logger.e(
      '❌ ERROR: $message$errorMessage',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void success(String message, [Map<String, dynamic>? data]) {
    _logger.i('✅ SUCCESS: ${_formatMessage(message, data)}');
  }

  static void auth(String message, [Map<String, dynamic>? data]) {
    _logger.i('🔐 AUTH: ${_formatMessage(message, data)}');
  }
}
