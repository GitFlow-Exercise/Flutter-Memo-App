import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_grid_item.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_view_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class RecentFilesScreen extends ConsumerWidget {

  const RecentFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentFilesViewModelProvider);
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
    final viewModel = ref.read(recentFilesViewModelProvider.notifier);
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
            onBookmark: (Workbook workbook) {
              viewModel.toggleBookmark(workbook);
            },
            onEdit: (Workbook workbook) {
              print('Edit: ${workbook.workbookId}');
            },
            onDelete: (Workbook workbook) {
              print('Delete: ${workbook.workbookId}');
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListView(WidgetRef ref, List<Workbook> workbookList) {
    final viewModel = ref.read(recentFilesViewModelProvider.notifier);
    return ListView.separated(
      itemCount: workbookList.length,
      itemBuilder: (context, index) {
        return WorkbookListItem(
          workbook: workbookList[index],
          onClick: () {},
          onSelect: (Workbook workbook) {
            viewModel.selectWorkbook(workbook);
          },
          onBookmark: (Workbook workbook) {
            viewModel.toggleBookmark(workbook);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }

  void _showEditDialog(BuildContext context, Workbook workbook) {
    final controller = TextEditingController(text: workbook.workbookName);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.white,
        title: const Text('문제집 수정하기'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '문제집 이름',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.dispose();
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              controller.dispose();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}