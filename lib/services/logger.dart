import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Logger {
  static String? _cachedPath;

  static Future<String> _getLogFilePath() async {
    final dir = await getApplicationSupportDirectory();
    final logDir = Directory('${dir.path}/logs');

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    final date = DateTime.now();
    final fileName = '${date.year}-${_pad(date.month)}-${_pad(date.day)}.log';
    final fullPath = '${logDir.path}/$fileName';

    if (_cachedPath == null) {
      _cachedPath = fullPath;
      if (kDebugMode) {
        debugPrint('[LOGGER] Logs: $fullPath');
      }
    }

    return fullPath;
  }

  static Future<String> getLogsDirectoryPath() async {
    final dir = await getApplicationSupportDirectory();
    final logDir = Directory('${dir.path}/logs');
    if (!await logDir.exists()) await logDir.create(recursive: true);
    return logDir.path;
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static Future<void> _writeToFile(String text) async {
    final path = await _getLogFilePath();
    final file = File(path);
    await file.writeAsString('$text\n', mode: FileMode.append, flush: true);
  }

  static Future<void> e(String message, [StackTrace? stack]) async {
    final entry = _fmt(
      'ERROR',
      '$message${stack != null ? '\n$stack' : ''}',
    );
    if (kDebugMode) debugPrint(entry);
    await _writeToFile(entry);
  }

  static Future<void> payment({
    required String paymentId,
    required String methodId,
    required double amount,
    required String currency,
    required String storeId,
    required String storeName,
    required bool success,
    String? message,
  }) async {
    final entry = _fmt('PAYMENT', '''
Payment ID: $paymentId
Store: $storeName ($storeId)
Method: $methodId
Amount: $amount $currency
Status: ${success ? 'SUCCESS' : 'FAILED'}
Message: ${message ?? ''}
''');

    if (kDebugMode) debugPrint(entry);
    await _writeToFile(entry);
  }

  static String _fmt(String type, String msg) {
    final now = DateTime.now().toIso8601String();
    return '[$now][$type] $msg';
  }
}
