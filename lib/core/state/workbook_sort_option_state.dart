import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workbook_sort_option_state.g.dart';

enum WorkbookSortOption {
  creationDateDesc('최신 순'),
  creationDateAsc('오래된 순'),
  nameAsc('이름 오름차순'),
  nameDesc('이름 내림차순');

  final String label;
  const WorkbookSortOption(this.label);
}

@riverpod
class WorkbookSortOptionState extends _$WorkbookSortOptionState {
  @override
  WorkbookSortOption build() {
    // 기본값
    ref.keepAlive();
    return WorkbookSortOption.creationDateDesc;
  }

  void setOption(WorkbookSortOption option) {
    state = option;
  }

  void clear() {
    state = WorkbookSortOption.creationDateDesc;
  }

  static List<Workbook> sortWorkbookList(
      List<Workbook> workbookList,
      WorkbookSortOption option,
      ) {
    final list = [...workbookList]; // 복사
    list.sort((a, b) {
      switch (option) {
        case WorkbookSortOption.creationDateAsc:
          return a.createdAt.compareTo(b.createdAt);
        case WorkbookSortOption.creationDateDesc:
          return b.createdAt.compareTo(a.createdAt);
        case WorkbookSortOption.nameAsc:
          return a.workbookName.compareTo(b.workbookName);
        case WorkbookSortOption.nameDesc:
          return b.workbookName.compareTo(a.workbookName);
      }
    });
    return list;
  }
}