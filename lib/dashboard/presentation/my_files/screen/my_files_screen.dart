import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_folder_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/controller/my_files_action.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/controller/my_files_state.dart';

class MyFilesScreen extends StatelessWidget {
  final MyFilesState state;
  final void Function(MyFilesAction action) onAction;

  const MyFilesScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return state.workbookList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyFolderScreen();
        }
        return state.showGridView
            ? WorkbookGridView(
          workbookList: data,
          onClick: (int workbookId) => onAction(MyFilesAction.onClick(workbookId)),
          onSelectWorkbook: (workbook) => onAction(MyFilesAction.onSelectWorkbook(workbook)),
          onToggleBookmark: (workbook) => onAction(MyFilesAction.onToggleBookmark(workbook)),
          onMoveTrashWorkbook: (workbook) => onAction(MyFilesAction.onMoveTrashWorkbook(workbook)),
          onDrag: (workbookList) => onAction(MyFilesAction.onDrag(workbookList)),
        )
            : WorkbookListView(
          workbookList: data,
          onClick: (int workbookId) => onAction(MyFilesAction.onClick(workbookId)),
          onSelectWorkbook: (workbook) => onAction(MyFilesAction.onSelectWorkbook(workbook)),
          onToggleBookmark: (workbook) => onAction(MyFilesAction.onToggleBookmark(workbook)),
          onMoveTrashWorkbook: (workbook) => onAction(MyFilesAction.onMoveTrashWorkbook(workbook)),
          onDrag: (workbookList) => onAction(MyFilesAction.onDrag(workbookList)),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
