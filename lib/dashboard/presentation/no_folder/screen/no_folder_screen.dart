import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_folder_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/no_folder/controller/no_folder_action.dart';
import 'package:mongo_ai/dashboard/presentation/no_folder/controller/no_folder_state.dart';

class NoFolderScreen extends StatelessWidget {
  final NoFolderState state;
  final void Function(NoFolderAction action) onAction;

  const NoFolderScreen({super.key, required this.state, required this.onAction});

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
          onClick: (int workbookId) => onAction(NoFolderAction.onClick(workbookId)),
          onSelectWorkbook: (workbook) => onAction(NoFolderAction.onSelectWorkbook(workbook)),
          onToggleBookmark: (workbook) => onAction(NoFolderAction.onToggleBookmark(workbook)),
          onMoveTrashWorkbook: (workbook) => onAction(NoFolderAction.onMoveTrashWorkbook(workbook)),
          onDrag: (workbookList) => onAction(NoFolderAction.onDrag(workbookList)),
        )
            : WorkbookListView(
          workbookList: data,
          onClick: (int workbookId) => onAction(NoFolderAction.onClick(workbookId)),
          onSelectWorkbook: (workbook) => onAction(NoFolderAction.onSelectWorkbook(workbook)),
          onToggleBookmark: (workbook) => onAction(NoFolderAction.onToggleBookmark(workbook)),
          onMoveTrashWorkbook: (workbook) => onAction(NoFolderAction.onMoveTrashWorkbook(workbook)),
          onDrag: (workbookList) => onAction(NoFolderAction.onDrag(workbookList)),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
