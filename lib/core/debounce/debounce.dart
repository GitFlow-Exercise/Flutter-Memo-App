import 'dart:async';
import 'package:flutter/foundation.dart';

/// 마지막 호출 후 [delay] 시간만큼 대기한 뒤에야 [action]이 실행됩니다.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
