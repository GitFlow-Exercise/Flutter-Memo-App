import 'package:flutter/material.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
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
        case Error():
        // 여기서 알림등 에러 처리 가능.
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
        // 성공 시 문제집 리스트를 리프레시
        refreshWorkbookList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

  Future<void> permanentDeleteWorkbook(Workbook workbook) async {
    final result = await ref.read(workbookRepositoryProvider).deleteWorkbook(workbook);
    switch (result) {
      case Success(data: final data):
        // 성공 시 문제집 리스트를 리프레시
        refreshWorkbookList();
        break;
      case Error(error: final error):
        debugPrint(error.message);
        // 여기서 알림등 에러 처리 가능.
        break;
    }
  }

}