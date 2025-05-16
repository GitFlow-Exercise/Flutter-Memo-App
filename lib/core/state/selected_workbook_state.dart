import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_workbook_state.g.dart';

class SelectedWorkbookStateModel {
  final List<Workbook> selectedWorkbooks;
  final bool isSelectMode;
  final bool isMergeMode;

  const SelectedWorkbookStateModel({
    this.selectedWorkbooks = const <Workbook>[],
    this.isSelectMode = false,
    this.isMergeMode = false,
  });

  SelectedWorkbookStateModel copyWith({
    List<Workbook>? selectedWorkbooks,
    bool? isSelectMode,
    bool? isMergeMode,
  }) {
    return SelectedWorkbookStateModel(
      selectedWorkbooks: selectedWorkbooks ?? this.selectedWorkbooks,
      isSelectMode: isSelectMode ?? this.isSelectMode,
      isMergeMode: isMergeMode ?? this.isMergeMode,
    );
  }
}

@riverpod
class SelectedWorkbookState extends _$SelectedWorkbookState {
  @override
  SelectedWorkbookStateModel build() {
    // keepAlive 필요 없음. 다른 페이지가면 리빌드 됨.
    return const SelectedWorkbookStateModel();
  }

  void selectWorkbook(Workbook workbook) {
    final current = state;
    final updatedList =
        current.selectedWorkbooks.contains(workbook)
            ? current.selectedWorkbooks.where((w) => w != workbook).toList()
            : [...current.selectedWorkbooks, workbook];
    state = current.copyWith(selectedWorkbooks: updatedList);
  }

  /// 전체 선택 해제
  void clear() {
    state = state.copyWith(selectedWorkbooks: <Workbook>[]);
  }

  void enableSelectMode() {
    state = state.copyWith(isSelectMode: true);
  }

  void disableSelectMode() {
    state = state.copyWith(isSelectMode: false);
    clear();
  }

  /// Merge 모드 토글 삭제 예정
  void toggleMergeMode() {
    if(state.isMergeMode) {
      state = state.copyWith(isMergeMode: false);
      clear();
    } else {
      state = state.copyWith(isMergeMode: true);
    }
  }
}
