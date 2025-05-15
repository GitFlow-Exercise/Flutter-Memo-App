import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class SelectModeButtonWidget extends ConsumerWidget {
  final void Function() onClick;

  const SelectModeButtonWidget({super.key, required this.onClick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    final selectedWorkbookList = ref.watch(selectedWorkbookStateProvider).selectedWorkbooks;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: onClick,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelectMode ? AppColor.paleBlue : AppColor.primary,
              side:
                  isSelectMode
                      ? const BorderSide(color: AppColor.primary, width: 2)
                      : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                isSelectMode
                    ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: AppColor.primary),
                        Gap(8),
                        Text(
                          '병합 취소하기',
                          style: TextStyle(color: AppColor.primary),
                        ),
                      ],
                    )
                    : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers, color: AppColor.white),
                        Gap(8),
                        Text(
                          '문서 병합하기',
                          style: TextStyle(color: AppColor.white),
                        ),
                      ],
                    ),
          ),
        ),
        isSelectMode ? const Gap(10) : const SizedBox.shrink(),
        isSelectMode
            ? badges.Badge(
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.circle,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: AppColor.white),
                  ),
                ),
              ),
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
