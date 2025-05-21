import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_view/deleted_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_view/deleted_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_trash_screen.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_action.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_state.dart';

class DeletedFilesScreen extends StatelessWidget {
  final DeletedFilesState state;
  final void Function(DeletedFilesAction action) onAction;

  const DeletedFilesScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return state.workbookList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyTrashScreen();
        }
        return state.showGridView
            ? DeletedGridView(
          workbookList: data,
          onSelectWorkbook: (workbook) => onAction(DeletedFilesAction.onSelectWorkbook(workbook)),
          onPermanentDeleteWorkbook: (workbook) => onAction(DeletedFilesAction.onPermanentDeleteWorkbook(workbook)),
          onRestoreWorkbook: (workbook) => onAction(DeletedFilesAction.onRestoreWorkbook(workbook)),
          onDrag: (workbookList) => onAction(DeletedFilesAction.onDrag(workbookList)),
        )
            : DeletedListView(
          workbookList: data,
          onSelectWorkbook: (workbook) => onAction(DeletedFilesAction.onSelectWorkbook(workbook)),
          onPermanentDeleteWorkbook: (workbook) => onAction(DeletedFilesAction.onPermanentDeleteWorkbook(workbook)),
          onRestoreWorkbook: (workbook) => onAction(DeletedFilesAction.onRestoreWorkbook(workbook)),
          onDrag: (workbookList) => onAction(DeletedFilesAction.onDrag(workbookList)),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
