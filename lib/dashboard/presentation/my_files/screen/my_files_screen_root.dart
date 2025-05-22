import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_folder_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/team_not_selected_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/controller/my_files_action.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/controller/my_files_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/screen/my_files_screen.dart';

class MyFilesScreenRoot extends ConsumerStatefulWidget {
  const MyFilesScreenRoot({super.key});

  @override
  ConsumerState<MyFilesScreenRoot> createState() => _MyFilesScreenRootState();
}

class _MyFilesScreenRootState extends ConsumerState<MyFilesScreenRoot> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myFilesViewModelProvider);
    if (state.currentTeamId == null) {
      return const TeamNotSelectedScreen();
    }
    return MyFilesScreen(
      state: state,
      onAction: _handleAction,
    );
  }

  void _handleAction(MyFilesAction action) {
    final viewModel = ref.read(myFilesViewModelProvider.notifier);
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
