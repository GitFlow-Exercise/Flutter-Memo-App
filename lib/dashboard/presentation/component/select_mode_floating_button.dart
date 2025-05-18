import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';

class SelectModeFloatingButton extends ConsumerWidget {
  final void Function() onClick;

  const SelectModeFloatingButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    return FloatingActionButton(
      onPressed: onClick,
      backgroundColor: isSelectMode ? Colors.red : Colors.blue,
    );
  }
}
