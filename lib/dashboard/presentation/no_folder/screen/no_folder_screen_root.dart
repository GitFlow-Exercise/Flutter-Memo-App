import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/team_not_selected_screen.dart';
import 'package:mongo_ai/dashboard/presentation/no_folder/controller/no_folder_action.dart';
import 'package:mongo_ai/dashboard/presentation/no_folder/controller/no_folder_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/no_folder/screen/no_folder_screen.dart';

class NoFolderScreenRoot extends ConsumerStatefulWidget {
  const NoFolderScreenRoot({super.key});

  @override
  ConsumerState<NoFolderScreenRoot> createState() => _NoFolderScreenRootState();
}

class _NoFolderScreenRootState extends ConsumerState<NoFolderScreenRoot> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noFolderViewModelProvider);
    if (state.currentTeamId == null) {
      return const TeamNotSelectedScreen();
    }
    return NoFolderScreen(
      state: state,
      onAction: _handleAction
    );
  }

  void _handleAction(NoFolderAction action) {
    final viewModel = ref.read(noFolderViewModelProvider.notifier);
    switch (action) {
      case OnClick(workbookId: final workbookId):
        print('클릭: $workbookId');
        viewModel.getProblemsByWorkbookId(workbookId);
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
