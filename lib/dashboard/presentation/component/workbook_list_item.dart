import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mongo_ai/core/state/selected_workbook_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

class WorkbookListItem extends ConsumerWidget {
  final void Function() onClick;
  final void Function() onBookmark;
  final Workbook workbook;
  const WorkbookListItem({
    super.key,
    required this.workbook,
    required this.onClick,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isSelected = ref.watch(selectedWorkbookStateProvider).selectedWorkbooks.contains(workbook);
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      workbook.workbookName,
                      style: AppTextStyle.headingMedium,
                    ),
                  ),
                  IconButton(
                    icon:
                        workbook.bookmark == true
                            ? const Icon(Icons.star, color: AppColor.secondary)
                            : const Icon(Icons.star_border),
                    onPressed: () => onBookmark(),
                  ),
                ],
              ),
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
      ),
    );
  }
}
