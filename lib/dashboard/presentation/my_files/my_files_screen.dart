import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_grid_view.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_view/workbook_list_view.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/controller/my_files_view_model.dart';

class MyFilesScreen extends ConsumerWidget {
  const MyFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myFilesViewModelProvider);
    final viewModel = ref.read(myFilesViewModelProvider.notifier);
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
