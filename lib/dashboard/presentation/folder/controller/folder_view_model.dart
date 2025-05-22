import 'package:flutter/material.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/extension/ref_extension.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_folder_id_state.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_view_model.g.dart';

@riverpod
class FolderViewModel extends _$FolderViewModel implements DashboardNavigationViewModel{
  @override
  FolderState build() {
    final currentTeamId = ref.watch(currentTeamIdStateProvider);
    final currentFolderId = ref.watch(currentFolderIdStateProvider);
    final workbookResult = ref.watch(getWorkbooksByCurrentTeamIdProvider);
    final filter = ref.watch(workbookFilterStateProvider);

    final workbookList = workbookResult.whenData((result) {
      switch (result) {
        case Success(data: final data):
          final folderData = data.where((workbook) => workbook.deletedAt == null && workbook.folderId == currentFolderId).toList();
          return WorkbookFilterState.applyWorkbookViewOption(folderData, filter);
        case Error(error: final error):
          debugPrint('Error: $error');
          return <Workbook>[];
      }
    });

    return FolderState(
      currentTeamId: currentTeamId,
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
      case Error(error: final error):
        debugPrint(error.message);
        ref.showSnackBar('북마크 수정에 실패하였습니다.');
        break;
    }
  }

  @override
  Future<void> moveTrashWorkbook(Workbook workbook) async {
    final result = await ref.read(moveTrashWorkbookUseCaseProvider).execute(workbook);
    switch(result) {
      case Success(data: final data):
        ref.showSnackBar('${data.workbookName}이(가) 휴지통으로 이동되었습니다.');
        refreshWorkbookList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        ref.showSnackBar('휴지통 이동에 실패하였습니다.');
        break;
    }
  }
}