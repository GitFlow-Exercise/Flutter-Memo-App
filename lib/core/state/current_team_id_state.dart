import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_team_id_state.g.dart';

@riverpod
class CurrentTeamIdState extends _$CurrentTeamIdState {

  //Todo: SharedPreference 등으로 저장하는 것으로 리팩토링 할 것
  @override
  int? build() {
    // 초기에는 아무 팀도 선택되지 않음.
    // keepAlive로 리빌드 되지 않게 막음.
    ref.keepAlive();
    return null;
  }

  /// 팀 선택 시 호출
  void set(int id) {
    state = id;
  }

  /// 선택 해제 시 호출
  void clear() {
    state = null;
  }
}
