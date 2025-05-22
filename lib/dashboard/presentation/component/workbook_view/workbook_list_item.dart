import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/presentation/component/button/hover_icon_button.dart';

class WorkbookListItem extends ConsumerWidget {
  final void Function() onClick;
  final void Function() onSelect;
  final void Function() onBookmark;
  final void Function() onMoveTrash;
  final Workbook workbook;

  const WorkbookListItem({
    super.key,
    required this.workbook,
    required this.onClick,
    required this.onSelect,
    required this.onBookmark,
    required this.onMoveTrash,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref
        .watch(selectedWorkbookStateProvider)
        .selectedWorkbooks
        .contains(workbook);
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    return GestureDetector(
      onTap: () {
        if (isSelectMode) {
          onSelect();
        } else {
          onClick();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColor.paleBlue : AppColor.white,
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            isSelected
                ? BoxShadow(
              color: AppColor.primary.withAlpha(150),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
                :
            BoxShadow(
              color: AppColor.deepBlack.withAlpha(50),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workbook.workbookName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.headingMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.person, color: AppColor.lightGray),
                              const SizedBox(width: 5),
                              Text(
                                workbook.userName ?? 'Unknown',
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColor.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.groups, color: AppColor.lightGray),
                              const SizedBox(width: 5),
                              Text(
                                workbook.teamName,
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColor.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.folder, color: AppColor.lightGray),
                              const SizedBox(width: 5),
                              Text(
                                workbook.folderName ?? 'Unknown',
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColor.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.timer_sharp,
                                color: AppColor.lightGray,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                DateFormat(
                                  'yyyy-MM-dd HH:mm',
                                ).format(workbook.createdAt),
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColor.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  HoverIconButton(
                    icon: workbook.bookmark
                        ? Icons.star
                        : Icons.star_border,
                    color: workbook.bookmark
                        ? AppColor.secondary
                        : AppColor.paleGray,
                    hideHover: isSelectMode,
                    onTap: () {
                      if (isSelectMode) {
                        onSelect();
                      } else {
                        onBookmark();
                      }
                    },
                  ),
                  const Gap(10),
                  HoverIconButton(
                    icon: Icons.close,
                    color: AppColor.destructive,
                    hideHover: isSelectMode,
                    onTap: () {
                      if (isSelectMode) {
                        onSelect();
                      } else {
                        onMoveTrash();
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
