import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

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
              '총 8개 문제',
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
              (context, candidateData, rejectedData) => SizedBox(
                height: 500,
                child: ListView.separated(
                  itemCount: problemList.length,
                  separatorBuilder: (context, index) => const Gap(12),
                  itemBuilder: (context, index) {
                    return Draggable<Problem>(
                      data: problemList[index],
                      feedback: Material(
                        child: SizedBox(
                          width: 500,
                          child: ProblemCardWidget(
                            title: problemList[index].title,
                            content: problemList[index].content,
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: ProblemCardWidget(
                          title: problemList[index].title,
                          content: problemList[index].content,
                        ),
                      ),
                      child: ProblemCardWidget(
                        title: problemList[index].title,
                        content: problemList[index].content,
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

class ProblemCardWidget extends StatelessWidget {
  final String title;
  final String content;
  final int? maxLines;
  const ProblemCardWidget({
    super.key,
    required this.title,
    required this.content,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.paleBlue,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text('객관식', style: TextStyle(fontSize: 12)),
              ),
              const Icon(
                Icons.drag_handle_outlined,
                color: AppColor.lighterGray,
              ),
            ],
          ),
          const Gap(8),
          Text(
            title,
            style: AppTextStyle.labelMedium.copyWith(
              color: AppColor.mediumGray,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(8),
          Text(
            content,
            style: AppTextStyle.labelMedium.copyWith(
              color: AppColor.mediumGray,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
