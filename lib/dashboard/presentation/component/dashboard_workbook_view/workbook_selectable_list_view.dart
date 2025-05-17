import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/dashboard_workbook_view/base_selectable_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/dashboard_workbook_view/workbook_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';

class WorkbookSelectableListView<T extends DashboardNavigationViewModel>
    extends BaseSelectableView<Workbook> {

  WorkbookSelectableListView({
    super.key,
    required List<Workbook> workbookList,
    required T viewModel,
  }) : super(
    items: workbookList,
    itemBuilder: (context, workbook) => WorkbookListItem(
      workbook: workbook,
      onClick: () {},
      onSelect: (_) => viewModel.selectWorkbook(workbook),
      onBookmark: (_) => viewModel.toggleBookmark(workbook),
      onMoveTrash: (_)   => viewModel.moveTrashWorkbook(workbook),
      onBookmarkList: () => viewModel.bookmarkWorkbookList(true),
      onRemoveBookmarkList: () => viewModel.bookmarkWorkbookList(false),
      onMoveTrashList: () => viewModel.moveTrashWorkbookList(),
    ),
    layoutBuilder: (ctx, children) => ListView.separated(
      itemCount: children.length,
      itemBuilder: (ctx, index) {
        return children[index];
      },
      separatorBuilder: (ctx, index) => const Gap(10),
    ),
    onSelection: (selected) {
      for (var workbook in selected) {
        viewModel.selectWorkbook(workbook);
      }
    },

    onDragStart: () {
      viewModel.enableSelectMode();
    },
    /// 드래그 끝났는데 선택 안 된 경우, 선택 모드 끄기
    onDragEndEmpty: () {
      viewModel.disableSelectMode();
    },
  );
}