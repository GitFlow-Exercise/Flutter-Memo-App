import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class MergeButtonWidget extends ConsumerWidget {
  final void Function() onMerge;
  final void Function() onToggleSelectMode;

  const MergeButtonWidget({super.key, required this.onMerge, required this.onToggleSelectMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmptySelectedList = ref.watch(selectedWorkbookStateProvider).selectedWorkbooks.isEmpty;
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (isEmptySelectedList) {
            onToggleSelectMode();
          } else {
            onMerge();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isEmptySelectedList ? AppColor.paleBlue : AppColor.circle,
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
             Icon(Icons.layers, color: isEmptySelectedList ? AppColor.primary : AppColor.white),
            const Gap(8),
            Text(
              '문서 병합하기',
              style: TextStyle(color: isEmptySelectedList ? AppColor.primary : AppColor.white),
            ),
          ],
        ),
      ),
    );
  }
}
