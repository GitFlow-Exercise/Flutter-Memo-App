import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

class DeletedGridItem extends ConsumerWidget {
  final void Function() onSelect;
  final void Function() onPermanentDelete;
  final void Function() onRestore;
  final Workbook workbook;

  const DeletedGridItem({super.key,
    required this.workbook,
    required this.onSelect,
    required this.onPermanentDelete,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleteMode = ref.watch(deletedWorkbookStateProvider).isDeleteMode;
    final isSelected = ref
        .watch(deletedWorkbookStateProvider)
        .deletedWorkbooks
        .contains(workbook);
    return GestureDetector(
      onTap: () {
        if (isDeleteMode) {
          onSelect();
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
                                    if (isDeleteMode) {
                                      onSelect();
                                    } else {
                                      onRestore();
                                    }
                                  },
                                  child: const Icon(
                                    Icons.restore,
                                    size: 24,
                                    color: AppColor.primary
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
                                workbook.folderName ?? 'Unknown',
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
                        const Text('삭제 : '),
                        Text(
                          DateFormat(
                            'yyyy-MM-dd HH:mm',
                          ).format(workbook.deletedAt!),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (isDeleteMode) {
                              onSelect();
                            } else {
                              onPermanentDelete();
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
