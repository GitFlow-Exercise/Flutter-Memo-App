import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

class WorkbookListItem extends ConsumerWidget {
  final void Function() onClick;
  final void Function(Workbook workbook) onSelect;
  final void Function(Workbook workbook) onBookmark;
  final void Function(Workbook workbook) onMoveTrash;
  final void Function() onBookmarkList;
  final void Function() onRemoveBookmarkList;
  final void Function() onMoveTrashList;
  final Workbook workbook;

  const WorkbookListItem({
    super.key,
    required this.workbook,
    required this.onClick,
    required this.onSelect,
    required this.onBookmark,
    required this.onMoveTrash,
    required this.onBookmarkList,
    required this.onRemoveBookmarkList,
    required this.onMoveTrashList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref
        .watch(selectedWorkbookStateProvider)
        .selectedWorkbookList
        .contains(workbook);
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    final controller = MenuController();
    return MenuAnchor(
        controller: controller,
        menuChildren: [
          MenuItemButton(
            onPressed: onBookmarkList,
            leadingIcon: const Icon(Icons.star, color: AppColor.secondary),
            child: const Text('문제집 북마크하기'),
          ),
          MenuItemButton(
            onPressed: onRemoveBookmarkList,
            leadingIcon: const Icon(Icons.star_border),
            child: const Text('문제집 북마크 해제하기'),
          ),
          MenuItemButton(
            onPressed: () {
              onMoveTrashList();
            },
            leadingIcon: const Icon(Icons.delete, color: AppColor.destructive),
            child: const Text('문제집 삭제하기'),
          ),
        ],
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColor.white),
        ),
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (isSelectMode) {
              onSelect(workbook);
            } else {
              onClick();
            }
          },
          onSecondaryTapDown: (details) {
            if (isSelectMode) {
              controller.open(position: details.localPosition);
            }
          },
          onLongPressStart: (details) {
            if (isSelectMode) {
              controller.open(position: details.localPosition);
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
                      GestureDetector(
                        onTap: () {
                          if(isSelectMode) {
                            onSelect(workbook);
                          } else {
                            onBookmark(workbook);
                          }
                        },
                        child: Icon(
                          workbook.bookmark
                              ? Icons.star
                              : Icons.star_border,
                          size: 24,
                          color:
                          workbook.bookmark
                              ? AppColor.secondary
                              : AppColor.paleGray,
                        ),
                      ),
                      const Gap(10),
                      GestureDetector(
                        onTap: () {
                          if(isSelectMode) {
                            onSelect(workbook);
                          } else {
                            onMoveTrash(workbook);
                          }
                        },
                        child: const Icon(
                            Icons.close,
                            size: 24,
                            color: AppColor.destructive
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
