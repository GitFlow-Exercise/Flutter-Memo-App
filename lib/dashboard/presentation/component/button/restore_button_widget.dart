import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class RestoreButtonWidget extends ConsumerWidget {
  final void Function() onRestoreAll;
  final void Function() onRestoreSelected;
  const RestoreButtonWidget({super.key, required this.onRestoreAll, required this.onRestoreSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmptySelectedList = ref.watch(deletedWorkbookStateProvider).deletedWorkbooks.isEmpty;
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (isEmptySelectedList) {
            onRestoreAll();
          } else {
            onRestoreSelected();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isEmptySelectedList ? AppColor.paleBlue : AppColor.primary,
          side: isEmptySelectedList
              ? const BorderSide(color: AppColor.primary, width: 2)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restore, color: isEmptySelectedList ? AppColor.primary : AppColor.white),
            const Gap(8),
            isEmptySelectedList
                ? const Text(
              '전부 복원하기',
              style: TextStyle(color: AppColor.primary),
            )
                : const Text(
              '선택 복원하기',
              style: TextStyle(color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }
}
