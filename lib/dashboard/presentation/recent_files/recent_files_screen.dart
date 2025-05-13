import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/controller/recent_files_view_model.dart';

class RecentFilesScreen extends ConsumerWidget {

  const RecentFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentFilesViewModelProvider);
    final viewModel = ref.read(recentFilesViewModelProvider.notifier);
    return Container(
      color: AppColor.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  viewModel.refreshWorkbookList();
                },
              ),
            ),
          ),
          Expanded(
            child: state.workbookList.when(
              data: (data) {
                return ListView.separated(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return WorkbookListItem(
                        workbook: data[index],
                        onClick: () {},
                        onBookmark: () {},
                      );
                    },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (e, _) => const SizedBox.shrink(),
            ),
          )
        ],
      )
    );
  }
}