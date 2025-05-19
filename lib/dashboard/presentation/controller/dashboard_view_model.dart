import 'package:flutter/material.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/enum/workbook_sort_option.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_folder_id_state.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
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

  // 외부에서 호출할 수 있도록 유저 업데이트 메서드 추가
  Future<void> updateUserProfile(UserProfile userProfile) async {
    state = state.whenData((value) => value.copyWith(userProfile: userProfile));
  }

  // -----------------
  // Team 관련 메서드
  Future<void> refreshTeamList() async {
    await ref.refresh(getTeamsByCurrentUserProvider.future);
  }

  Future<void> refreshWorkbookList() async {
    ref.refresh(getWorkbooksByCurrentTeamIdProvider);
  }

  // 최근에 선택한 팀 설정하기
  Future<void> fetchSelectedTeam() async {
    final authRepository = ref.read(authRepositoryProvider);
    final teamId = authRepository.getSelectedTeamId();
    if (teamId != null) {
      selectTeam(teamId);
    }
  }

  // -----------------
  // Folder 관련 메서드
  Future<void> selectFolderId(int folderId) async {
    ref.read(currentFolderIdStateProvider.notifier).set(folderId);
  }

  Future<void> clearFolderId() async {
    ref.read(currentFolderIdStateProvider.notifier).clear();
  }

  Future<void> refreshFolderList() async {
    await ref.refresh(getFoldersByCurrentTeamIdProvider.future);
  }

  Future<void> createFolder(String folderName) async {
    final currentTeamId = ref.read(currentTeamIdStateProvider);
    if (currentTeamId != null) {
      final result = await ref
          .read(folderRepositoryProvider)
          .createFolder(
            FolderDto(folderName: folderName, teamId: currentTeamId),
          );

      switch (result) {
        case Success(data: final data):
          // 성공 시 폴더 리스트를 리프레시
          refreshFolderList();
          break;
        case Error(error: final error):
          debugPrint(error.message);
          // 여기서 알림등 에러 처리 가능.
          break;
      }
    }
  }

  Future<void> updateFolder(Folder folder) async {
    final result = await ref
        .read(folderRepositoryProvider)
        .updateFolder(folder);

    switch (result) {
      case Success(data: final data):
        // 성공 시 폴더 리스트를 리프레시
        refreshFolderList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

  Future<void> deleteFolder(Folder folder) async {
    final result = await ref
        .read(folderRepositoryProvider)
        .deleteFolder(folder);

    switch (result) {
      case Success(data: final data):
        // 성공 시 폴더 리스트를 리프레시
        refreshFolderList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

  // -----------------
  // Workbook Filter 기능 메서드
  Future<void> changeFilterSortOption(WorkbookSortOption option) async {
    ref.read(workbookFilterStateProvider.notifier).setSortOption(option);
  }

  Future<void> toggleFilterShowBookmark() async {
    ref.read(workbookFilterStateProvider.notifier).toggleShowBookmark();
  }

  Future<void> toggleFilterShowGridView(bool showGridView) async {
    ref
        .read(workbookFilterStateProvider.notifier)
        .toggleShowGridView(showGridView);
  }

  // -----------------
  // workbook List 처리 메서드
  Future<void> changeFolderWorkbookList(int folderId) async {
    final workbookList = ref.read(selectedWorkbookStateProvider).selectedWorkbooks;
    final result = await ref.read(changeFolderWorkbookListUseCaseProvider).execute(workbookList, folderId);
    switch (result) {
      case Success(data: final data):
        // 성공 시 workbook 리스트를 리프레시
        ref.read(selectedWorkbookStateProvider.notifier).clear();
        refreshWorkbookList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

  Future<void> moveTrashWorkbookList() async {
    final workbookList = ref.read(selectedWorkbookStateProvider).selectedWorkbooks;
    final result = await ref.read(moveTrashWorkbookListUseCaseProvider).execute(workbookList);
    switch (result) {
      case Success(data: final data):
        // 성공 시 workbook 리스트를 리프레시
        ref.read(selectedWorkbookStateProvider.notifier).clear();
        refreshWorkbookList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

  // -----------------
  // workbook 선택 모드 메서드
  Future<void> toggleSelectMode() async {
    ref.read(selectedWorkbookStateProvider.notifier).toggleSelectMode();
  }

  // -----------------
  // Team 선택 메서드
  /// 팀 선택 시 currentTeamIdStateProvider 변하면서 자동 리빌드 됨.
  Future<void> selectTeam(int teamId) async {
    ref.read(currentTeamIdStateProvider.notifier).set(teamId);
  }
}
