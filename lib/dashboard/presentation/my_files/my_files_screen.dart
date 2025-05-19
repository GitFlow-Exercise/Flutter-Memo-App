import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/empty_folder_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/empty_screen/team_not_selected_screen.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/controller/my_files_view_model.dart';

class MyFilesScreen extends ConsumerWidget {
  const MyFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myFilesViewModelProvider);
    final viewModel = ref.read(myFilesViewModelProvider.notifier);
    if(state.currentTeamId == null) {
      return const TeamNotSelectedScreen();
    }
    return state.workbookList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyFolderScreen();
        }
        return state.showGridView
            ? WorkbookGridView(workbookList: data, viewModel: viewModel, onClick: (int workbookId) {print('클릭: $workbookId');},)
            : WorkbookListView(workbookList: data, viewModel: viewModel, onClick: (int workbookId) {print('클릭: $workbookId');},);
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
