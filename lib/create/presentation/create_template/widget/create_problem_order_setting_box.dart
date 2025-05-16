import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/problem_card_widget.dart';

class CreateProblemOrderSettingBox extends StatelessWidget {
  final List<Problem> orderedProblemList;
  final int totalLength;
  final void Function(Problem problem) onAcceptOrderedProblem;
  final VoidCallback onTapClear;

  const CreateProblemOrderSettingBox({
    super.key,
    required this.orderedProblemList,
    required this.onAcceptOrderedProblem,
    required this.onTapClear,
    required this.totalLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          text: ' ${orderedProblemList.length}',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                        TextSpan(
                          text: '/$totalLength',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(5),
                  GestureDetector(
                    onTap: onTapClear,
                    child: Row(
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
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
          Expanded(
            child: DragTarget<Problem>(
              onAcceptWithDetails:
                  (details) => onAcceptOrderedProblem(details.data),
              builder: (context, candidateData, rejectedData) {
                return SingleChildScrollView(
                  child: DottedBorder(
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
                          Container(
                            constraints: const BoxConstraints(minHeight: 500),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: orderedProblemList.length,
                              separatorBuilder:
                                  (context, index) => const Gap(24),
                              itemBuilder: (context, index) {
                                return Draggable<Problem>(
                                  data: orderedProblemList[index],
                                  feedback: Material(
                                    child: SizedBox(
                                      width: 300,
                                      child: ProblemCardWidget(
                                        number:
                                            orderedProblemList[index].number,
                                        question:
                                            orderedProblemList[index].question,
                                        passage:
                                            orderedProblemList[index].passage,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.5,
                                    child: ProblemCardWidget(
                                      number: orderedProblemList[index].number,
                                      question:
                                          orderedProblemList[index].question,
                                      passage:
                                          orderedProblemList[index].passage,
                                      maxLines: 5,
                                    ),
                                  ),
                                  child: ProblemCardWidget(
                                    number: orderedProblemList[index].number,
                                    question:
                                        orderedProblemList[index].question,
                                    passage: orderedProblemList[index].passage,
                                    maxLines: 5,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
