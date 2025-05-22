import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_folder_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_action.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_state.dart';

class RecentFilesScreen extends StatelessWidget {
  final RecentFilesState state;
  final void Function(RecentFilesAction action) onAction;

  const RecentFilesScreen({super.key, required this.state, required this.onAction});

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
                onClick: (int workbookId) => onAction(RecentFilesAction.onClick(workbookId)),
                onSelectWorkbook: (workbook) => onAction(RecentFilesAction.onSelectWorkbook(workbook)),
                onToggleBookmark: (workbook) => onAction(RecentFilesAction.onToggleBookmark(workbook)),
                onMoveTrashWorkbook: (workbook) => onAction(RecentFilesAction.onMoveTrashWorkbook(workbook)),
                onDrag: (workbookList) => onAction(RecentFilesAction.onDrag(workbookList)),
              )
            : WorkbookListView(
                workbookList: data,
                onClick: (int workbookId) => onAction(RecentFilesAction.onClick(workbookId)),
                onSelectWorkbook: (workbook) => onAction(RecentFilesAction.onSelectWorkbook(workbook)),
                onToggleBookmark: (workbook) => onAction(RecentFilesAction.onToggleBookmark(workbook)),
                onMoveTrashWorkbook: (workbook) => onAction(RecentFilesAction.onMoveTrashWorkbook(workbook)),
                onDrag: (workbookList) => onAction(RecentFilesAction.onDrag(workbookList)),
             );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
