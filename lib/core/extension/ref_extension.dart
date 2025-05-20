import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/event/app_event.dart';
import 'package:mongo_ai/core/event/app_event_provider.dart';

// Ref에 이벤트 헬퍼를 추가하는 Extension입니다.
// - 기존 뷰모델의 구조를 바꾸지 않고 Ref에 메서드를 붙일 수 있습니다.
// 사용법 예시: `ref.showSnackBar("...")`, `ref.navigate("/home")`처럼 호출이 직관적이고 짧아집니다.
extension EventHelpers on Ref {
  void showSnackBar(String message) {
    read(
      appEventProvider.notifier,
    ).addEvent(AppEventState.showSnackBar(message: message));
  }

  void navigate(
    String routeName, {
    dynamic extra,
    NavigationMethod navigateMethod = NavigationMethod.go,
  }) {
    read(appEventProvider.notifier).addEvent(
      AppEventState.navigate(
        routeName: routeName,
        extra: extra,
        navigateMethod: navigateMethod,
      ),
    );
  }
}
