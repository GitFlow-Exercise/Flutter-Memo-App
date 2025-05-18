import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/dashboard_workbook_view/workbook_selectable_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/dashboard_workbook_view/workbook_selectable_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_view_model.dart';

import '../../../core/state/selected_workbook_state.dart';

class RecentFilesScreen extends ConsumerWidget {

  const RecentFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentFilesViewModelProvider);
    final viewModel = ref.read(recentFilesViewModelProvider.notifier);
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
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