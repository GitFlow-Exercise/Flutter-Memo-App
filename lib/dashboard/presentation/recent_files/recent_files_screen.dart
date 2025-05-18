import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_view_model.dart';

class RecentFilesScreen extends ConsumerWidget {

  const RecentFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentFilesViewModelProvider);
    final viewModel = ref.read(recentFilesViewModelProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: state.workbookList.when(
        data: (data) {
          return state.showGridView
              ? WorkbookGridView(workbookList: data, viewModel: viewModel)
              : WorkbookListView(workbookList: data, viewModel: viewModel);
        },
        loading: () => const SizedBox.shrink(),
        error: (e, _) => const SizedBox.shrink(),
      ),
    );
  }
}