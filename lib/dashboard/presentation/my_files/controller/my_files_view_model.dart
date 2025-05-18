import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/controller/my_files_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'my_files_view_model.g.dart';

@riverpod
class MyFilesViewModel extends _$MyFilesViewModel implements DashboardNavigationViewModel {
  @override
  MyFilesState build() {
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;
    final workbookResult = ref.watch(getWorkbooksByCurrentTeamIdProvider);
    final filter = ref.watch(workbookFilterStateProvider);

    final workbookList = workbookResult.whenData((result) {
      switch (result) {
        case Success(data: final data):
          final workbookData = data.where((workbook) => workbook.deletedAt == null && workbook.userId == currentUserId).toList();
          return WorkbookFilterState.applyWorkbookViewOption(workbookData, filter);
        case Error():
        // 여기서 알림등 에러 처리 가능.
          return <Workbook>[];
      }
    });

    return MyFilesState(
      workbookList: workbookList,
      showGridView: filter.showGridView,
    );
  }

  @override
  Future<void> moveTrashWorkbook(Workbook workbook) {
    // TODO: implement moveTrashWorkbook
    throw UnimplementedError();
  }

  @override
  Future<void> refreshWorkbookList() {
    // TODO: implement refreshWorkbookList
    throw UnimplementedError();
  }

  @override
  Future<void> selectWorkbook(Workbook workbook) {
    // TODO: implement selectWorkbook
    throw UnimplementedError();
  }

  @override
  Future<void> toggleBookmark(Workbook workbook) {
    // TODO: implement toggleBookmark
    throw UnimplementedError();
  }
}