import 'package:flutter/material.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/controller/dashboard_navigation_view_model.dart';

class WorkbookListView<T extends DashboardNavigationViewModel> extends StatelessWidget {
  final List<Workbook> workbookList;
  final T viewModel;
  const WorkbookListView({super.key, required this.workbookList, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: workbookList.length,
      itemBuilder: (context, index) {
        return WorkbookListItem(
          workbook: workbookList[index],
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
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
