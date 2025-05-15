import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_files_view_model.g.dart';

@riverpod
class RecentFilesViewModel extends _$RecentFilesViewModel {
  @override
  RecentFilesState build() {
    final workbookResult = ref.watch(getWorkbooksByCurrentTeamIdProvider);
    final filter = ref.watch(workbookFilterStateProvider);

    // Result를 ViewModel에서 처리.
    // 로딩 처리를 위해 whenData로 AsyncValue를 반환.
    final workbookList = workbookResult.whenData((result) {
      switch (result) {
        case Success(data: final data):
          return WorkbookFilterState.applyWorkbookViewOption(data, filter);
        case Error():
          // 여기서 알림등 에러 처리 가능.
          return <Workbook>[];
      }
    });

    return RecentFilesState(
      workbookList: workbookList,
      showGridView: filter.showGridView,
    );
  }

  // ------------------------
  // 문서 병합모드 메서드
  Future<void> selectWorkbook(Workbook workbook) async {
    ref.read(selectedWorkbookStateProvider.notifier).selectWorkbook(workbook);
  }

  // ------------------------
  // Workbook DB 메서드
  Future<void> refreshWorkbookList() async {
    ref.refresh(getWorkbooksByCurrentTeamIdProvider);
  }

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

  // Future<void> updateWorkbook(Workbook workbook) async {
  //   final result = await ref.read(updateWorkbookUseCaseProvider).execute(workbook);
  //   switch(result) {
  //     case Success(data: final data):
  //       refreshWorkbookList();
  //       break;
  //     case Error():
  //       print('Error: ${result.error}');
  //       // 여기서 알림등 에러 처리 가능.
  //       break;
  //   }
  // }

  Future<void> deleteWorkbook(Workbook workbook) async {
    final result = await ref.read(deleteWorkbookUseCaseProvider).execute(workbook);
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
