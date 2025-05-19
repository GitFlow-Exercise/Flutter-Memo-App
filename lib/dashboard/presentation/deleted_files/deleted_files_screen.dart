import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/deleted_files_info_widget.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_trash_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/team_not_selected_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/deleted_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/deleted_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';

class DeletedFilesScreen extends ConsumerWidget {
  const DeletedFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deletedFilesViewModelProvider);
    final viewModel = ref.read(deletedFilesViewModelProvider.notifier);
    if(state.currentTeamId == null) {
      return const TeamNotSelectedScreen();
    }
    return state.workbookList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyTrashScreen();
        }
        return Stack(
          children: [
            state.showGridView
                ? DeletedGridView(workbookList: data, viewModel: viewModel)
                : DeletedListView(workbookList: data, viewModel: viewModel),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 90,
              child: const DeletedFilesInfoWidget(),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
