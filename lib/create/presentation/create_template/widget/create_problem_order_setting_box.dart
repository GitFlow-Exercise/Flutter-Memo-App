import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

class CreateProblemOrderSettingBox extends StatefulWidget {
  const CreateProblemOrderSettingBox({super.key});

  @override
  State<CreateProblemOrderSettingBox> createState() =>
      _CreateProblemOrderSettingBoxState();
}

class _CreateProblemOrderSettingBoxState
    extends State<CreateProblemOrderSettingBox> {
  List<Problem> problems = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: AppColor.lightGrayBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '문제 순서',
                  style: AppTextStyle.headingMedium.copyWith(
                    color: AppColor.mediumGray,
                  ),
                ),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '문제 수:',
                            style: AppTextStyle.labelMedium.copyWith(
                              color: AppColor.lightGray,
                            ),
                          ),
                          TextSpan(
                            text: ' 3',
                            style: AppTextStyle.labelMedium.copyWith(
                              color: AppColor.primary,
                            ),
                          ),
                          TextSpan(
                            text: '/8',
                            style: AppTextStyle.labelMedium.copyWith(
                              color: AppColor.lightGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Row(
                      children: [
                        const Icon(Icons.delete, color: AppColor.destructive),
                        Text(
                          '모두 지우기',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.destructive,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Gap(16),
            DragTarget<Problem>(
              onAcceptWithDetails: (details) {
                setState(() {
                  problems.add(details.data);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  dashPattern: const [8, 4],
                  color: AppColor.lightGrayBorder,
                  strokeWidth: 2,
                  child: Container(
                    padding: const EdgeInsets.all(35.0),
                    color: AppColor.textfieldGrey,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: AppColor.paleGray,
                          size: 24,
                        ),
                        const Gap(12),
                        Text(
                          '왼쪽의 문제를 이곳에 드래그하여 추가하세요',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(22),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: problems.length,
                          separatorBuilder: (context, index) => const Gap(24),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(14.0),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                border: Border.all(
                                  color: AppColor.lightGrayBorder,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.paleBlue,
                                          borderRadius: BorderRadius.circular(
                                            99,
                                          ),
                                        ),
                                        child: const Text(
                                          '객관식',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.drag_handle_outlined,
                                        color: AppColor.lighterGray,
                                      ),
                                    ],
                                  ),
                                  const Gap(8),
                                  Text(
                                    problems[index].title,
                                    style: AppTextStyle.labelMedium.copyWith(
                                      color: AppColor.mediumGray,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Gap(8),
                                  Text(
                                    problems[index].content,
                                    style: AppTextStyle.labelMedium.copyWith(
                                      color: AppColor.mediumGray,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
