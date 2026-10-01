import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that ignores notifications sent after disposal.
///
/// The view models keep working while a request is in flight, so a screen that
/// is popped mid-request would otherwise hit the "used after being disposed"
/// assertion when the response finally lands.
mixin SafeNotifier on ChangeNotifier {
  bool _disposed = false;

  bool get isDisposed => _disposed;

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
