import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_folder_id_state.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_view_model.g.dart';

@riverpod
class FolderViewModel extends _$FolderViewModel implements DashboardNavigationViewModel {
  @override
  FolderState build() {
    final currentFolderId = ref.watch(currentFolderIdStateProvider);
    final workbookResult = ref.watch(getWorkbooksByCurrentTeamIdProvider);
    final filter = ref.watch(workbookFilterStateProvider);

    final workbookList = workbookResult.whenData((result) {
      switch (result) {
        case Success(data: final data):
          final folderData = data.where((workbook) => workbook.deletedAt == null && workbook.folderId == currentFolderId).toList();
          return WorkbookFilterState.applyWorkbookViewOption(folderData, filter);
        case Error():
          // 여기서 알림등 에러 처리 가능.
          return <Workbook>[];
      }
    });

    return FolderState(
      workbookList: workbookList,
      showGridView: filter.showGridView,
    );
  }

  // ------------------------
  // 문서 병합모드 메서드
  @override
  Future<void> selectWorkbook(Workbook workbook) async {
    ref.read(selectedWorkbookStateProvider.notifier).selectWorkbook(workbook);
  }

  @override
  Future<void> enableSelectMode() async {
    ref.read(selectedWorkbookStateProvider.notifier).enableSelectMode();
  }

  @override
  Future<void> disableSelectMode() async {
    ref.read(selectedWorkbookStateProvider.notifier).disableSelectMode();
  }

  // ------------------------
  // Workbook DB 메서드
  @override
  Future<void> refreshWorkbookList() async {
    ref.refresh(getWorkbooksByCurrentTeamIdProvider);
  }

  @override
  Future<void> toggleBookmark(Workbook workbook) async {
    final result = await ref.read(toggleBookmarkUseCaseProvider).execute(workbook);
    switch(result) {
      case Success(data: final data):
        refreshWorkbookList();
        break;
      case Error():
        print('Error: ${result.error}');
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

  @override
  Future<void> moveTrashWorkbook(Workbook workbook) async {
    final result = await ref.read(moveTrashWorkbookUseCaseProvider).execute(workbook);
    switch(result) {
      case Success(data: final data):
        refreshWorkbookList();
        break;
      case Error():
        print('Error: ${result.error}');
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

  @override
  Future<void> bookmarkWorkbookList(bool bookmark) async {
    final workbookList = ref.read(selectedWorkbookStateProvider).selectedWorkbookList;
    final result = await ref.read(bookmarkWorkbookListUseCaseProvider).execute(workbookList, bookmark);
    switch(result) {
      case Success(data: final data):
        refreshWorkbookList();
        break;
      case Error():
        print('Error: ${result.error}');
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

  @override
  Future<void> moveTrashWorkbookList() async {
    final workbookList = ref.read(selectedWorkbookStateProvider).selectedWorkbookList;
    final result = await ref.read(moveTrashWorkbookListUseCaseProvider).execute(workbookList);
    switch(result) {
      case Success(data: final data):
        refreshWorkbookList();
        break;
      case Error():
        print('Error: ${result.error}');
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }
}