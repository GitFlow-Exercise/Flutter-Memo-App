import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mongo_ai/core/state/deleted_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

class DeletedListItem extends ConsumerWidget {
  final void Function(Workbook workbook) onSelect;
  final void Function(Workbook workbook) onPermanentDelete;
  final void Function(Workbook workbook) onRestore;
  final Workbook workbook;

  const DeletedListItem({
    super.key,
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
    return Container(
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
                              ).format(workbook.deletedAt!),
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
                    onRestore(workbook);
                  },
                  child: const Icon(
                      Icons.restore,
                      size: 24,
                      color: AppColor.circle
                  ),
                ),
                const Gap(10),
                GestureDetector(
                  onTap: () {
                    onPermanentDelete(workbook);
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
    );
  }
}
