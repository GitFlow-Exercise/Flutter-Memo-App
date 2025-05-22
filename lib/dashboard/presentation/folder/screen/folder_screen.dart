import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_folder_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_action.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_state.dart';

class FolderScreen extends StatelessWidget {
  final FolderState state;
  final void Function(FolderAction action) onAction;

  const FolderScreen({super.key, required this.state, required this.onAction});

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
          onClick: (int workbookId) => onAction(FolderAction.onClick(workbookId)),
          onSelectWorkbook: (workbook) => onAction(FolderAction.onSelectWorkbook(workbook)),
          onToggleBookmark: (workbook) => onAction(FolderAction.onToggleBookmark(workbook)),
          onMoveTrashWorkbook: (workbook) => onAction(FolderAction.onMoveTrashWorkbook(workbook)),
          onDrag: (workbookList) => onAction(FolderAction.onDrag(workbookList)),
        )
            : WorkbookListView(
          workbookList: data,
          onClick: (int workbookId) => onAction(FolderAction.onClick(workbookId)),
          onSelectWorkbook: (workbook) => onAction(FolderAction.onSelectWorkbook(workbook)),
          onToggleBookmark: (workbook) => onAction(FolderAction.onToggleBookmark(workbook)),
          onMoveTrashWorkbook: (workbook) => onAction(FolderAction.onMoveTrashWorkbook(workbook)),
          onDrag: (workbookList) => onAction(FolderAction.onDrag(workbookList)),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
