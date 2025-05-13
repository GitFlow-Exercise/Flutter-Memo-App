import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/enum/workbook_sort_option.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_folder_id_state.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/state/dashboard_path_state.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
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

    return DashboardState(
      currentTeamId: currentTeamId,
      userProfile: userProfile,
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

  // -----------------
  // Folder 선택 메서드
  Future<void> selectFolderId(int folderId) async {
    ref.read(currentFolderIdStateProvider.notifier).set(folderId);
  }

  Future<void> clearFolderId() async {
    ref.read(currentFolderIdStateProvider.notifier).clear();
  }

  // -----------------
  // Workbook Filter 기능 메서드
  Future<void> changeFilterSortOption(WorkbookSortOption option) async {
    ref.read(workbookFilterStateProvider.notifier).setSortOption(option);
  }

  Future<void> toggleFilterShowBookmark() async {
    ref.read(workbookFilterStateProvider.notifier).toggleShowBookmark();
  }

  Future<void> toggleFilterShowGridView() async {
    ref.read(workbookFilterStateProvider.notifier).toggleShowGridView();
  }

  // -----------------
  // path 업데이트 메서드
  Future<void> updatePath(List<String> path) async {
    ref.read(dashboardPathStateProvider.notifier).set(path);
  }

  // -----------------
  // Team 선택 메서드
  /// 팀 선택 시 currentTeamIdStateProvider 변하면서 자동 리빌드 됨.
  Future<void> selectTeam(int teamId) async {
    ref.read(currentTeamIdStateProvider.notifier).set(teamId);
  }
}
