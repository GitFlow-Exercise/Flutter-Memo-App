import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class CleanTrashButton extends ConsumerWidget {
  final void Function() onCleanAll;
  final void Function() onDeleteSelected;
  const CleanTrashButton({super.key, required this.onCleanAll, required this.onDeleteSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmptySelectedList = ref.watch(deletedWorkbookStateProvider).deletedWorkbooks.isEmpty;
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (isEmptySelectedList) {
            onCleanAll();
          } else {
            onDeleteSelected();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isEmptySelectedList ? AppColor.paleBlue : AppColor.destructive,
          side: isEmptySelectedList
              ? const BorderSide(color: AppColor.destructive, width: 2)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.layers, color: isEmptySelectedList ? AppColor.destructive : AppColor.white),
            const Gap(8),
            isEmptySelectedList
                ? const Text(
                  '휴지통 비우기',
                  style: TextStyle(color: AppColor.destructive),
                )
                : const Text(
                    '선택 삭제하기',
                    style: TextStyle(color: AppColor.white),
                  ),
          ],
        ),
      ),
    );
  }
}
