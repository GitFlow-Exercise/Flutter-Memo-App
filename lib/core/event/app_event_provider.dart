import 'package:mongo_ai/core/event/app_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_event_provider.g.dart';

// 앱 이벤트를 전역적으로 관리합니다.
// 메인 시작점에서 listen을 실행합니다.
// listen 자체는 아주 가벼운 편이고,
// 이벤트가 실제로 발생했을 때만 로직이 돌아가므로 큰 부담은 없습니다.
@riverpod
class AppEvent extends _$AppEvent {
  @override
  AppEventState? build() {
    // 기본 상태값은 null
    return null;
  }

  // 이벤트 상태를 변경 후
  // 다시 사용하기 위해
  // null로 변환시킵니다.
  void addEvent(AppEventState event) async {
    state = event;
    state = null;
  }
}
