import 'package:flutter/foundation.dart';

class ApiLogger {
  static void error({
    required String operation,
    required Object error,
    StackTrace? stackTrace,
  }) {
    debugPrint('[API ERROR] $operation: $error');
    if (stackTrace != null) {
      debugPrintStack(
        label: '[API ERROR] Stack trace',
        stackTrace: stackTrace,
      );
    }
  }
}
