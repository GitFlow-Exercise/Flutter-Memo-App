import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_folder_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/team_not_selected_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_action.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/folder/screen/folder_screen.dart';

class FolderScreenRoot extends ConsumerStatefulWidget {
  const FolderScreenRoot({super.key});

  @override
  ConsumerState<FolderScreenRoot> createState() => _FolderScreenRootState();
}

class _FolderScreenRootState extends ConsumerState<FolderScreenRoot> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(folderViewModelProvider);
    if (state.currentTeamId == null) {
      return const TeamNotSelectedScreen();
    }
    return FolderScreen(
      state: state,
      onAction: _handleAction
    );
  }

  void _handleAction(FolderAction action) {
    final viewModel = ref.read(folderViewModelProvider.notifier);
    switch (action) {
      case OnClick(workbookId: final workbookId):
        print('클릭: $workbookId');
        break;
      case OnSelectWorkbook(workbook: final workbook):
        viewModel.selectWorkbook(workbook);
        break;
      case OnToggleBookmark(workbook: final workbook):
        viewModel.toggleBookmark(workbook);
        break;
      case OnMoveTrashWorkbook(workbook: final workbook):
        viewModel.moveTrashWorkbook(workbook);
        break;
      case OnDrag(workbookList: final workbookList):
        for(final workbook in workbookList) {
          viewModel.selectWorkbook(workbook);
        }
        break;
    }
  }
}
