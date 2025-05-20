import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class SelectModeButtonWidget extends ConsumerWidget {
  final void Function() onToggleSelectMode;

  const SelectModeButtonWidget({super.key, required this.onToggleSelectMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    final selectedWorkbookList = ref.watch(selectedWorkbookStateProvider).selectedWorkbooks;

    if(!isSelectMode) {
      return SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: onToggleSelectMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.paleBlue,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColor.primary, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Center(
            child: Icon(Icons.edit, color: AppColor.primary),
          ),
        ),
      );
    }

    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -10, end: -6),
      badgeStyle: const badges.BadgeStyle(
        badgeColor: AppColor.destructive,
      ),
      badgeContent: Text(
        selectedWorkbookList.length.toString(),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: onToggleSelectMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.circle,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Center(
            child: Icon(Icons.folder, color: AppColor.white),
          ),
        ),
      ),
    );
  }
}
