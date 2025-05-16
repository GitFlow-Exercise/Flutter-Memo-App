import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/dashboard_workbook_view/workbook_selectable_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/dashboard_workbook_view/workbook_selectable_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_view_model.dart';

class FolderScreen extends ConsumerWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(folderViewModelProvider);
    final viewModel = ref.read(folderViewModelProvider.notifier);
    return state.workbookList.when(
      data: (data) {
        return state.showGridView
            ? WorkbookSelectableGridView(workbookList: data, viewModel: viewModel)
            : WorkbookSelectableListView(workbookList: data, viewModel: viewModel);
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
