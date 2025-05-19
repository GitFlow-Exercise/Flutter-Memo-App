import 'package:flutter/material.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/deleted_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';

class DeletedListView<T extends DeletedFilesViewModel> extends StatelessWidget {
  final List<Workbook> workbookList;
  final T viewModel;

  const DeletedListView({super.key, required this.workbookList, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 90),
      itemCount: workbookList.length,
      itemBuilder: (context, index) {
        return DeletedListItem(
          workbook: workbookList[index],
          onSelect: (Workbook workbook) {
          },
          onPermanentDelete: (Workbook workbook) {
            viewModel.permanentDeleteWorkbook(workbook);
          },
          onRestore: (Workbook workbook) {
            viewModel.restoreWorkbook(workbook);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
