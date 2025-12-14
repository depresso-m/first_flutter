import 'dart:async';

/// Utility class for debouncing actions
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// Run the action after the delay, cancelling any previous pending action
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending action
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Check if there's a pending action
  bool get isPending => _timer?.isActive ?? false;

  /// Dispose the debouncer
  void dispose() {
    cancel();
  }
}
