import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_files_view_model.g.dart';

@riverpod
class RecentFilesViewModel extends _$RecentFilesViewModel {
  @override
  RecentFilesState build() {
    final workbookResult = ref.watch(getWorkbooksByCurrentTeamIdProvider);

    // Result를 ViewModel에서 처리.
    // 로딩 처리를 위해 whenData로 AsyncValue를 반환.
    final workbookList = workbookResult.whenData((result) {
      switch (result) {
        case Success(data: final data):
          return result.data;
        case Error():
          // 여기서 알림등 에러 처리 가능.
          return <Workbook>[];
      }
    });

    return RecentFilesState(
      workbookList: workbookList,
    );
  }

  Future<void> refreshWorkbookList() async {
    ref.refresh(getWorkbooksByCurrentTeamIdProvider);
  }
}
