import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

class WorkbookGridItem extends StatelessWidget {
  final void Function() onClick;
  final void Function() onBookmark;
  final Workbook workbook;

  const WorkbookGridItem({
    super.key,
    required this.workbook,
    required this.onClick,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.deepBlack.withAlpha(50),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: AppColor.white,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                                behavior: HitTestBehavior.translucent,
                                onTap: onBookmark,
                                child: Icon(
                                  workbook.bookmark ? Icons.star : Icons.star_border,
                                  size: 24,
                                  color: workbook.bookmark ? AppColor.secondary : AppColor.paleGray,
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          children: [
                            Spacer(),
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
                            Spacer(),
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
                    top: BorderSide(color: AppColor.lightGrayBorder, width: 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Text('수정 : '),
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm').format(workbook.createdAt),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
