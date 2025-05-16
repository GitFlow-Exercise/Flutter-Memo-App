import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deleted_workbook_state.g.dart';

class DeletedWorkbookStateModel {
  final List<Workbook> deletedWorkbooks;
  final bool isDeleteMode;

  const DeletedWorkbookStateModel({
    this.deletedWorkbooks = const <Workbook>[],
    this.isDeleteMode = false,
  });

  DeletedWorkbookStateModel copyWith({
    List<Workbook>? deletedWorkbooks,
    bool? isDeleteMode,
  }) {
    return DeletedWorkbookStateModel(
      deletedWorkbooks: deletedWorkbooks ?? this.deletedWorkbooks,
      isDeleteMode: isDeleteMode ?? this.isDeleteMode,
    );
  }
}

@riverpod
class DeletedWorkbookState extends _$DeletedWorkbookState {
  @override
  DeletedWorkbookStateModel build() {
    // keepAlive 필요 없음. 다른 페이지가면 리빌드 됨.
    return const DeletedWorkbookStateModel();
  }

  /// 워크북을 삭제(또는 복원) 리스트에 추가/제거
  void toggleDeletedWorkbook(Workbook workbook) {
    final current = state;
    final updatedList = current.deletedWorkbooks.contains(workbook)
        ? current.deletedWorkbooks.where((w) => w != workbook).toList()
        : [...current.deletedWorkbooks, workbook];
    state = current.copyWith(deletedWorkbooks: updatedList);
  }

  /// 모든 삭제 리스트 비우기
  void clearDeleted() {
    state = state.copyWith(deletedWorkbooks: <Workbook>[]);
  }

  /// 삭제 모드 토글
  void toggleDeleteMode() {
    if (state.isDeleteMode) {
      // 모드 off 시, 리스트도 초기화
      state = state.copyWith(isDeleteMode: false);
      clearDeleted();
    } else {
      state = state.copyWith(isDeleteMode: true);
    }
  }
}