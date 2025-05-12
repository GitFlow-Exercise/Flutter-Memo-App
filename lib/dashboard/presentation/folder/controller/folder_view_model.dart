import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/state/current_folder_path_state.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_view_model.g.dart';

@riverpod
class FolderViewModel extends _$FolderViewModel {
  @override
  FolderState build() {
    final folderPath = ref.watch(currentFolderPathStateProvider);
    final workbookResult = ref.watch(getWorkbooksByCurrentTeamIdProvider);

    final workbookList = workbookResult.whenData((result) {
      switch (result) {
        case Success(data: final data):
          if(folderPath.isNotEmpty) {
            return result.data.where((workbook) => workbook.folderId == folderPath.last.folderId).toList();
          }
          return <Workbook>[];
        case Error():
        // 여기서 알림등 에러 처리 가능.
          return <Workbook>[];
      }
    });

    return FolderState(
      workbookList: workbookList,
    );
  }

  Future<void> refreshWorkbookList() async {
    ref.refresh(getWorkbooksByCurrentTeamIdProvider);
  }
}