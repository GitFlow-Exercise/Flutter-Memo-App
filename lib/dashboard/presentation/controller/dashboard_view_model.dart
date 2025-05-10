import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';

part 'dashboard_view_model.g.dart';

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  Future<DashboardState> build() async {
    // Todo: 팀 선택 시 SharedPreferences에 저장하고 비동기로 바꾸기
    final currentTeamId = ref.watch(currentTeamIdStateProvider);
    final userProfile = await _fetchUserProfile();
    final teamList = await _fetchTeamList();

    return DashboardState(
      userProfile: userProfile,
      teamList: teamList,
      currentTeamId: currentTeamId,
    );
  }

  Future<UserProfile> _fetchUserProfile() async {
    final result = await ref.watch(getCurrentUserProfileProvider.future);
    return switch (result) {
      Success(data: final data) => data,
      Error() => const UserProfile(userId: '', userName: ''),
    };
  }

  Future<List<Team>> _fetchTeamList() async {
    final result = await ref.watch(getTeamsByCurrentUserProvider.future);
    return switch (result) {
      Success(data: final data) => data,
      Error() => <Team>[],
    };
  }

  Future<void> refreshFolderList(int? teamId) async {
    await ref.refresh(getFoldersByCurrentTeamIdProvider(teamId).future);
  }

  /// 팀 선택 시 currentTeamIdStateProvider 변하면서 자동 리빌드 됨.
  Future<void> selectTeam(int teamId) async {
    ref.read(currentTeamIdStateProvider.notifier).set(teamId);
  }
}
