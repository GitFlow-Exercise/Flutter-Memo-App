import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/dashboard/presentation/component/workbook_list_item.dart';
import 'package:mongo_ai/dashboard/presentation/folder/controller/folder_view_model.dart';

class FolderScreen extends ConsumerWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(folderViewModelProvider);
    final viewModel = ref.read(folderViewModelProvider.notifier);
    return Container(
      color: AppColor.white,
      child: Column(
        children: [
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
          ),
        ],
      ),
    );
  }
}
