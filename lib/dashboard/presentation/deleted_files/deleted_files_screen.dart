import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/deleted_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/component/deleted_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/controller/deleted_files_view_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class DeletedFilesScreen extends ConsumerWidget {
  const DeletedFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deletedFilesViewModelProvider);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: state.workbookList.when(
        data: (data) {
          return state.showGridView
              ? _buildDeleteGridView(ref, data)
              : _buildDeleteListView(ref, data);
        },
        loading: () => const SizedBox.shrink(),
        error: (e, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDeleteGridView(WidgetRef ref, List<Workbook> workbookList) {
    final viewModel = ref.read(deletedFilesViewModelProvider.notifier);
    return ResponsiveGridList(
      minItemWidth: 280, // 원하는 아이템 최소 너비
      children: workbookList.map((workbook) {
        return AspectRatio(
          aspectRatio: 1, // 비율 유지
          child: DeletedGridItem(
            workbook: workbook,
            onSelect: (Workbook workbook) {
            },
            onPermanentDelete: (Workbook workbook) {
              viewModel.permanentDeleteWorkbook(workbook);
            },
            onRestore: (Workbook workbook) {
              viewModel.restoreWorkbook(workbook);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeleteListView(WidgetRef ref, List<Workbook> workbookList) {
    final viewModel = ref.read(deletedFilesViewModelProvider.notifier);
    return ListView.separated(
      itemCount: workbookList.length,
      itemBuilder: (context, index) {
        return DeletedListItem(
          workbook: workbookList[index],
          onSelect: (Workbook workbook) {
          },
          onPermanentDelete: (Workbook workbook) {
            viewModel.permanentDeleteWorkbook(workbook);
          },
          onRestore: (Workbook workbook) {
            viewModel.restoreWorkbook(workbook);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
