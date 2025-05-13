import 'package:mongo_ai/core/enum/workbook_sort_option.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workbook_filter_state.g.dart';

class WorkbookFilter {
  final WorkbookSortOption sortOption;
  final bool showBookmark;
  final bool showGridView;

  const WorkbookFilter({
    this.sortOption = WorkbookSortOption.creationDateDesc,
    this.showBookmark = false,
    this.showGridView = true,
  });

  WorkbookFilter copyWith({
    WorkbookSortOption? sortOption,
    bool? showBookmark,
    bool? showGridView,
  }) {
    return WorkbookFilter(
      sortOption: sortOption ?? this.sortOption,
      showBookmark: showBookmark ?? this.showBookmark,
      showGridView: showGridView ?? this.showGridView,
    );
  }
}

@riverpod
class WorkbookFilterState extends _$WorkbookFilterState {
  @override
  WorkbookFilter build() {
    // 기본값
    ref.keepAlive();
    return const WorkbookFilter();
  }

  void setSortOption(WorkbookSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void toggleShowBookmark() {
    state = state.copyWith(showBookmark: !state.showBookmark);
  }

  void toggleShowGridView() {
    state = state.copyWith(showGridView: !state.showGridView);
  }

  static List<Workbook> applyWorkbookViewOption(
      List<Workbook> workbooks,
      WorkbookFilter filter,
      ) {

    // 리스트 복사본 생성
    List<Workbook> list = [...workbooks];

    // 북마크 표시 있으면 필터링
    if (filter.showBookmark) {
      list = list.where((w) => w.bookmark).toList();
    }

    // 정렬 옵션에 따라 정렬
    list.sort((a, b) {
      switch (filter.sortOption) {
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