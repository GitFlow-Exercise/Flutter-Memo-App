import 'package:flutter/material.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/dashboard_workbook_view/workbook_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/component/dashboard_workbook_view/base_selectable_view.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

// Workbook 뿐만 아니라 다른 페이지에서도 사용할 수 있도록 제네릭으로 설정
class WorkbookSelectableGridView<T extends DashboardNavigationViewModel>
    extends BaseSelectableView<Workbook> {

  WorkbookSelectableGridView({
    super.key,
    required List<Workbook> workbookList,
    required T viewModel,
  }) : super(
    items: workbookList,
    itemBuilder: (context, workbook) => AspectRatio(
      aspectRatio: 1,
      child: WorkbookGridItem(
        workbook: workbook,
        onClick: () {},
        onSelect: (_) => viewModel.selectWorkbook(workbook),
        onBookmark: (_) => viewModel.toggleBookmark(workbook),
        onMoveTrash: (_)   => viewModel.moveTrashWorkbook(workbook),
        onBookmarkList: () => viewModel.bookmarkWorkbookList(true),
        onRemoveBookmarkList: () => viewModel.bookmarkWorkbookList(false),
        onMoveTrashList: () => viewModel.moveTrashWorkbookList(),
      ),
    ),
    layoutBuilder: (ctx, children) => ResponsiveGridList(
      minItemWidth: 280,
      children: children,
    ),
    onSelection: (selected) {
      for (var workbook in selected) {
        viewModel.selectWorkbook(workbook);
      }
    },
  );
}