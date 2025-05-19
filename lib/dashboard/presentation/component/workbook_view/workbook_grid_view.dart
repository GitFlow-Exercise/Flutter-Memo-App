import 'package:flutter/material.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class WorkbookGridView<T extends DashboardNavigationViewModel> extends StatelessWidget {
  final List<Workbook> workbookList;
  final T viewModel;
  const WorkbookGridView({super.key, required this.workbookList, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
      verticalGridMargin: 30,
      horizontalGridMargin: 30,
      minItemWidth: 280, // 원하는 아이템 최소 너비
      children: workbookList.map((workbook) {
        return AspectRatio(
          aspectRatio: 1, // 비율 유지
          child: WorkbookGridItem(
            workbook: workbook,
            onClick: () {},
            onSelect: (Workbook workbook) {
              viewModel.selectWorkbook(workbook);
            },
            onBookmark: (Workbook workbook) {
              viewModel.toggleBookmark(workbook);
            },
            onDelete: (Workbook workbook) {
              viewModel.moveTrashWorkbook(workbook);
            },
          ),
        );
      }).toList(),
    );
  }
}
