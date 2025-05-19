import 'package:flutter/material.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/deleted_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class DeletedGridView<T extends DeletedFilesViewModel> extends StatelessWidget {
  final List<Workbook> workbookList;
  final T viewModel;

  const DeletedGridView({super.key, required this.workbookList, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
      verticalGridMargin: 90,
      horizontalGridMargin: 30,
      minItemWidth: 280, // 원하는 아이템 최소 너비
      children: workbookList.map((workbook) {
        return AspectRatio(
          aspectRatio: 1, // 비율 유지
          child: DeletedGridItem(
            workbook: workbook,
            onSelect: (Workbook workbook) {
            },
            onPermanentDelete: (Workbook workbook) {
              viewModel.permanentDeleteWorkbook(workbook);
            },
            onRestore: (Workbook workbook) {
              viewModel.restoreWorkbook(workbook);
            },
          ),
        );
      }).toList(),
    );
  }
}
