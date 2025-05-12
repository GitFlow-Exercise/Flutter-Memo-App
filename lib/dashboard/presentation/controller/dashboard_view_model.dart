import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_folder_id_state.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/state/workbook_sort_option_state.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_view_model.g.dart';

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  Future<DashboardState> build() async {
    final currentTeamId = ref.watch(currentTeamIdStateProvider);
    final userProfile = await _fetchUserProfile();
    // final teamList = await _fetchTeamList();

    return DashboardState(
      currentTeamId: currentTeamId,
      userProfile: userProfile,
      //teamList: teamList,
    );
  }

  Future<UserProfile> _fetchUserProfile() async {
    // User 데이터도 바뀌면 리빌드 되도록 watch 설정
    final result = await ref.watch(getCurrentUserProfileProvider.future);
    return switch (result) {
      Success(data: final data) => data,
      Error() => const UserProfile(userId: '', userName: ''),
    };
  }

  Future<void> refreshTeamList() async {
    await ref.refresh(getTeamsByCurrentUserProvider.future);
  }

  Future<void> refreshFolderList() async {
    await ref.refresh(getFoldersByCurrentTeamIdProvider.future);
  }

  Future<void> selectFolder(int folderId) async {
    ref.read(currentFolderIdStateProvider.notifier).set(folderId);
  }

  Future<void> clearFolder() async {
    ref.read(currentFolderIdStateProvider.notifier).clear();
  }

  Future<void> changeSortOption(WorkbookSortOption option) async {
    ref.read(workbookSortOptionStateProvider.notifier).setOption(option);
  }

  /// 팀 선택 시 currentTeamIdStateProvider 변하면서 자동 리빌드 됨.
  Future<void> selectTeam(int teamId) async {
    ref.read(currentTeamIdStateProvider.notifier).set(teamId);
  }
}
