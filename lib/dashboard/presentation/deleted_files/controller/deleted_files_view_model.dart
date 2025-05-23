import 'package:flutter/material.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/extension/ref_extension.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deleted_files_view_model.g.dart';

@riverpod
class DeletedFilesViewModel extends _$DeletedFilesViewModel {
  @override
  DeletedFilesState build() {
    final currentTeamId = ref.watch(currentTeamIdStateProvider);
    final workbookResult = ref.watch(getWorkbooksByCurrentTeamIdProvider);
    final filter = ref.watch(workbookFilterStateProvider);

    // Result를 ViewModel에서 처리.
    // 로딩 처리를 위해 whenData로 AsyncValue를 반환.
    final workbookList = workbookResult.whenData((result) {
      switch (result) {
        case Success(data: final data):
          final deletedWorkbookList = data.where((workbook) => workbook.deletedAt != null).toList();
          return WorkbookFilterState.applyWorkbookViewOption(deletedWorkbookList, filter);
        case Error(error: final error):
          debugPrint('Error: $error');
          return <Workbook>[];
      }
    });

    return DeletedFilesState(
      currentTeamId: currentTeamId,
      workbookList: workbookList,
      showGridView: filter.showGridView,
    );
  }

  // ------------------------
  // Workbook DB 메서드
  Future<void> refreshWorkbookList() async {
    ref.refresh(getWorkbooksByCurrentTeamIdProvider);
  }

  Future<void> restoreWorkbook(Workbook workbook) async {
    final restoredWorkbook = workbook.copyWith(deletedAt: null);
    final result = await ref.read(workbookRepositoryProvider).updateWorkbook(restoredWorkbook);
    switch (result) {
      case Success(data: final data):
        ref.showSnackBar('${data.workbookName}이(가) 복원되었습니다.');
        refreshWorkbookList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        ref.showSnackBar('복원에 실패하였습니다.');
        break;
    }
  }

  Future<void> permanentDeleteWorkbook(Workbook workbook) async {
    final result = await ref.read(workbookRepositoryProvider).deleteWorkbook(workbook);
    switch (result) {
      case Success(data: final data):
        ref.showSnackBar('${data.workbookName}이(가) 삭제되었습니다.');
        refreshWorkbookList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        ref.showSnackBar('삭제가 실패하였습니다.');
        break;
    }
  }

  Future<void> selectWorkbook(Workbook workbook) async {
    ref.read(deletedWorkbookStateProvider.notifier).selectDeletedWorkbook(workbook);
  }
}