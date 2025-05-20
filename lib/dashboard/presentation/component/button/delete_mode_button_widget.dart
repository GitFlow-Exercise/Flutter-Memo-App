import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class DeleteModeButtonWidget extends ConsumerWidget {
  final void Function() onToggleDeleteMode;

  const DeleteModeButtonWidget({super.key, required this.onToggleDeleteMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleteMode = ref.watch(deletedWorkbookStateProvider).isDeleteMode;
    final deletedWorkbookList = ref.watch(deletedWorkbookStateProvider).deletedWorkbooks;
    if(!isDeleteMode) {
      return SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: onToggleDeleteMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.paleBlue,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColor.destructive, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Center(
            child: Icon(Icons.edit, color: AppColor.destructive),
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
        deletedWorkbookList.length.toString(),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: onToggleDeleteMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.destructive,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Center(
            child: Icon(Icons.folder_delete, color: AppColor.white),
          ),
        ),
      ),
    );
  }
}
