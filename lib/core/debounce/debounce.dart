import 'dart:async';
import 'package:flutter/foundation.dart';

// 설정한 시간초 이내에서
// 마지막으로 실행된 함수 한 번만 실행
class Debouncer {
  final int seconds;
  Timer? _timer;

  Debouncer({required this.seconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(seconds: seconds), action);
  }
}
