import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_workbook_state.g.dart';

class SelectedWorkbookStateModel {
  final List<Workbook> selectedWorkbooks;
  final bool isSelectMode;

  const SelectedWorkbookStateModel({
    this.selectedWorkbooks = const <Workbook>[],
    this.isSelectMode = false,
  });

  SelectedWorkbookStateModel copyWith({
    List<Workbook>? selectedWorkbooks,
    bool? isSelectMode,
  }) {
    return SelectedWorkbookStateModel(
      selectedWorkbooks: selectedWorkbooks ?? this.selectedWorkbooks,
      isSelectMode: isSelectMode ?? this.isSelectMode,
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
    final updatedList = current.selectedWorkbooks.contains(workbook)
        ? current.selectedWorkbooks.where((w) => w != workbook).toList()
        : [...current.selectedWorkbooks, workbook];
    state = current.copyWith(selectedWorkbooks: updatedList);
  }

  /// 전체 선택 해제
  void clear() {
    state = state.copyWith(selectedWorkbooks: <Workbook>[]);
  }

  /// Select 모드 토글
  void toggleSelectMode() {
    if(state.isSelectMode) {
      state = state.copyWith(isSelectMode: false);
      clear();
    } else {
      state = state.copyWith(isSelectMode: true);
    }
  }
}
