import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

class WorkbookGridItem extends ConsumerWidget {
  final void Function() onClick;
  final void Function(Workbook workbook) onSelect;
  final void Function(Workbook workbook) onBookmark;
  final void Function(Workbook workbook) onDelete;
  final Workbook workbook;

  const WorkbookGridItem({
    super.key,
    required this.workbook,
    required this.onClick,
    required this.onSelect,
    required this.onBookmark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref
        .watch(selectedWorkbookStateProvider)
        .selectedWorkbooks
        .contains(workbook);
    final isSelectMode = ref.watch(selectedWorkbookStateProvider).isSelectMode;
    final controller = MenuController();
    return MenuAnchor(
        controller: controller,
        menuChildren: [
          MenuItemButton(
            onPressed: () {

            },
            leadingIcon: const Icon(Icons.star, color: AppColor.secondary),
            child: const Text('문제집 북마크하기'),
          ),
          MenuItemButton(
            onPressed: () {

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
            width: 250,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColor.deepBlack.withAlpha(50),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColor.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: AppColor.white,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 45,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        workbook.workbookName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis, // 넘칠 때 “…”
                                        softWrap: true, // 줄바꿈 허용
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: AppColor.deepBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
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
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Spacer(),
                                  _gridTile(
                                    Icons.person,
                                    workbook.userName ?? 'Unknown',
                                  ),
                                  const Gap(10),
                                  _gridTile(Icons.groups, workbook.teamName),
                                  const Gap(10),
                                  _gridTile(
                                    Icons.folder,
                                    workbook.folderName.toString(),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.paleBlue,
                        border: Border(
                          top: BorderSide(
                            color:
                                isSelected
                                    ? AppColor.primary
                                    : AppColor.lightGrayBorder,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            const Text('수정 : '),
                            Text(
                              DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(workbook.createdAt),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if(isSelectMode) {
                                  onSelect(workbook);
                                } else {
                                  onDelete(workbook);
                                }
                              },
                              child: const Icon(
                                Icons.close,
                                size: 24,
                                color: AppColor.destructive
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _gridTile(IconData icon, String text) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColor.paleBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: AppColor.lightGray),
            const Gap(10),
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.bodyRegular.copyWith(
                  color: AppColor.lightGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
