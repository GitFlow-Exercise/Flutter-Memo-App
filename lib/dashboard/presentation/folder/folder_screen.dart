import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_view_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class FolderScreen extends ConsumerWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(folderViewModelProvider);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: state.workbookList.when(
        data: (data) {
          return state.showGridView
              ? _buildGridView(ref, data)
              : _buildListView(ref, data);
        },
        loading: () => const SizedBox.shrink(),
        error: (e, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildGridView(WidgetRef ref, List<Workbook> workbookList) {
    final viewModel = ref.read(folderViewModelProvider.notifier);
    return ResponsiveGridList(
      minItemWidth: 280, // 원하는 아이템 최소 너비
      children: workbookList.map((workbook) {
        return AspectRatio(
          aspectRatio: 1, // 비율 유지
          child: WorkbookGridItem(
            workbook: workbook,
            onClick: () {},
            onSelect: (Workbook workbook) {
              viewModel.selectWorkbook(workbook);
            },
            onBookmark: () {},
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListView(WidgetRef ref, List<Workbook> workbookList) {
    final viewModel = ref.read(folderViewModelProvider.notifier);
    return ListView.separated(
      itemCount: workbookList.length,
      itemBuilder: (context, index) {
        return WorkbookListItem(
          workbook: workbookList[index],
          onClick: () {},
          onSelect: (Workbook workbook) {
            viewModel.selectWorkbook(workbook);
          },
          onBookmark: () {},
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
