import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/enum/workbook_sort_option.dart';
import 'package:mongo_ai/core/state/workbook_filter_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class WorkbookFilterSortWidget extends ConsumerWidget {
  final void Function(WorkbookSortOption option) changeSortOption;

  const WorkbookFilterSortWidget({super.key, required this.changeSortOption});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOption = ref.watch(workbookFilterStateProvider).sortOption;
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
      ),
      child: DropdownButton<WorkbookSortOption>(
        value: sortOption,
        underline: const SizedBox(),            // 밑줄 제거
        dropdownColor: AppColor.white,
        icon: const Icon(Icons.keyboard_arrow_down),
        onChanged: (changedOption) {
          if (changedOption != null) {
            changeSortOption(changedOption);
          }
        },
        items: WorkbookSortOption.values.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option.label),
          );
        }).toList(),
      ),
    );
  }
}
