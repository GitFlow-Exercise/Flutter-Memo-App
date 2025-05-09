import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

part 'dashboard_view_model.g.dart';

class DashboardData {
  final UserProfile userProfile;
  final List<Team> teamList;
  final List<Folder> folderList;
  final int? currentTeamId;

  DashboardData({
    required this.userProfile,
    required this.teamList,
    required this.folderList,
    this.currentTeamId
  });
}

@riverpod
class DashboardViewModel extends _$DashboardViewModel {

  @override
  Future<DashboardData> build() async {
    // 유저, 팀 정보, 선택된 팀 ID 가져오기
    final userProfileResult = await ref.watch(getCurrentUserProfileProvider.future);
    final teamResult = await ref.watch(getTeamsByCurrentUserProvider.future);

    // Todo: 팀 선택 시 SharedPreferences에 저장하고 비동기로 바꾸기
    // Todo: 보기 좋게 리팩토링 하기
    final currentTeamId = ref.watch(currentTeamIdStateProvider);

    final UserProfile userProfile = switch (userProfileResult) {
      Success(data: final data)   => data,
      Error(error: final error)   => UserProfile(
          userId: '',
          userName: ''
      ),
    };

    final List<Team> teamList = switch (teamResult) {
      Success(data: final data)   => data,
      Error(error: final error)   => [],
    };

    List<Folder> folderList = [];

    if (currentTeamId != null) {
      final foldersResult = await ref.watch(getFoldersByCurrentTeamIdProvider(currentTeamId).future);

      folderList = switch (foldersResult) {
        Success(data: final data)   => data,
        Error(error: final error)   => [],
      };
    }

    return DashboardData(
      userProfile: userProfile,
      teamList: teamList,
      folderList: folderList,
      currentTeamId: currentTeamId,
    );
  }

  /// 팀 선택 시 currentTeamIdStateProvider 변하면서 자동 리빌드 됨.
  Future<void> selectTeam(int teamId) async {
    ref.read(currentTeamIdStateProvider.notifier).set(teamId);
  }

  Future<void> refreshAll() async {
    // 1) 로딩 상태로 전환
    state = const AsyncLoading();

    // 2) 캐시 비우기
    ref.invalidate(getCurrentUserProfileProvider);
    ref.invalidate(getTeamsByCurrentUserProvider);

    // 3) build() 를 다시 호출 -> 새로 요청된 Future 로딩
    state = await AsyncValue.guard(() => build());
  }
}