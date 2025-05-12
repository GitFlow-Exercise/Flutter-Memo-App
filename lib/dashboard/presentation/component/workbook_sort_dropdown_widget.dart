import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/workbook_sort_option_state.dart';

class WorkbookSortDropdownWidget extends ConsumerWidget {
  final void Function(WorkbookSortOption option) onChanged;

  const WorkbookSortDropdownWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOption = ref.watch(workbookSortOptionStateProvider);
    return DropdownButton<WorkbookSortOption>(
      value: sortOption,
      underline: const SizedBox(),            // 밑줄 제거
      icon: const Icon(Icons.keyboard_arrow_down),
      onChanged: (changedOption) {
        if (changedOption != null) {
          onChanged(changedOption);
        }
      },
      items: WorkbookSortOption.values.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option.label),
        );
      }).toList(),
    );
  }
}
