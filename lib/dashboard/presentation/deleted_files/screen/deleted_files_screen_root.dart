import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_workbook_alert_dialog.dart';
import 'package:mongo_ai/dashboard/presentation/component/deleted_files_info_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_trash_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/team_not_selected_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_view/deleted_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/delete_view/deleted_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_action.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/screen/deleted_files_screen.dart';

class DeletedFilesScreenRoot extends ConsumerStatefulWidget {
  const DeletedFilesScreenRoot({super.key});

  @override
  ConsumerState<DeletedFilesScreenRoot> createState() => _DeletedFilesScreenRootState();
}

class _DeletedFilesScreenRootState extends ConsumerState<DeletedFilesScreenRoot> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(deletedFilesViewModelProvider);
    if(state.currentTeamId == null) {
      return const TeamNotSelectedScreen();
    }
    return DeletedFilesScreen(
      state: state,
      onAction: _handleAction
    );
  }

  void _handleAction(DeletedFilesAction action) {
    final viewModel = ref.read(deletedFilesViewModelProvider.notifier);
    switch (action) {
      case OnSelectWorkbook(workbook: final workbook):
        viewModel.selectWorkbook(workbook);
        break;
      case OnPermanentDeleteWorkbook(workbook: final workbook):
        showDialog(
          context: context,
          builder: (context) {
            return DeleteWorkbookAlertDialog(
              onDeleteWorkbook: () {
                viewModel.permanentDeleteWorkbook(workbook);
              },
              title: '문제집 삭제하기',
            );
          },
        );
        break;
      case OnRestoreWorkbook(workbook: final workbook):
        viewModel.restoreWorkbook(workbook);
        break;
      case OnDrag(workbookList: final workbookList):
        for(final workbook in workbookList) {
          viewModel.selectWorkbook(workbook);
        }
        break;
    }
  }
}
