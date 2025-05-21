import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_files_view_model.g.dart';

@riverpod
class RecentFilesViewModel extends _$RecentFilesViewModel implements DashboardNavigationViewModel {
  @override
  RecentFilesState build() {
    final currentTeamId = ref.watch(currentTeamIdStateProvider);
    final workbookResult = ref.watch(getWorkbooksByCurrentTeamIdProvider);
    final filter = ref.watch(workbookFilterStateProvider);

    // Result를 ViewModel에서 처리.
    // 로딩 처리를 위해 whenData로 AsyncValue를 반환.
    final workbookList = workbookResult.whenData((result) {
      switch (result) {
        case Success(data: final data):
          final workbookData = data.where((workbook) => workbook.deletedAt == null).toList();
          final recentWorkbookList = (workbookData..sort((a, b) => b.createdAt.compareTo(a.createdAt)))
              .take(10)
              .toList();
          return WorkbookFilterState.applyWorkbookViewOption(recentWorkbookList, filter);
        case Error():
          // 여기서 알림등 에러 처리 가능.
          return <Workbook>[];
      }
    });

    return RecentFilesState(
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
}
