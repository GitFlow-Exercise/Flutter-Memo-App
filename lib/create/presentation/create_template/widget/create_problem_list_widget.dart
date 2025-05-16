import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/problem_card_widget.dart';

class CreateProblemListWidget extends StatelessWidget {
  final List<Problem> problemList;
  final void Function(Problem problem) onAcceptProblem;
  const CreateProblemListWidget({
    super.key,
    required this.problemList,
    required this.onAcceptProblem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '문제 리스트',
              style: AppTextStyle.headingMedium.copyWith(
                color: AppColor.mediumGray,
              ),
            ),
            Text(
              '총 ${problemList.length}개 문제',
              style: AppTextStyle.labelMedium.copyWith(
                color: AppColor.paleGray,
              ),
            ),
          ],
        ),
        const Gap(12),
        DragTarget<Problem>(
          onAcceptWithDetails: (detail) => onAcceptProblem(detail.data),
          builder:
              (context, candidateData, rejectedData) => Container(
                constraints: const BoxConstraints(minHeight: 300),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: problemList.length,
                  separatorBuilder: (context, index) => const Gap(12),
                  itemBuilder: (context, index) {
                    return Draggable<Problem>(
                      data: problemList[index],
                      feedback: Material(
                        child: SizedBox(
                          width: 500,
                          child: ProblemCardWidget(
                            title: problemList[index].question,
                            content: problemList[index].passage,
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: ProblemCardWidget(
                          title: problemList[index].question,
                          content: problemList[index].passage,
                        ),
                      ),
                      child: ProblemCardWidget(
                        title: problemList[index].question,
                        content: problemList[index].passage,
                      ),
                    );
                  },
                ),
              ),
        ),
      ],
    );
  }
}
