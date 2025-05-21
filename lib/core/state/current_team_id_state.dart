import 'dart:async';

import 'package:mongo_ai/core/di/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_team_id_state.g.dart';

@riverpod
class CurrentTeamIdState extends _$CurrentTeamIdState {
  @override
  int? build() {
    // 초기에는 아무 팀도 선택되지 않음.
    // keepAlive로 리빌드 되지 않게 막음.
    ref.keepAlive();
    return null;
  }

  /// 팀 선택 시 호출
  void set(int id) {
    // 선택한 팀을 저장.
    unawaited(ref.read(authRepositoryProvider).saveSelectedTeamId(id));
    state = id;
  }

  /// 선택 해제 시 호출
  void clear() {
    state = null;
  }
}
