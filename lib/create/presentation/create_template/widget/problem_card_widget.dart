import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

class ProblemCardWidget extends StatelessWidget {
  final Problem problem;
  final int? maxLines;
  final bool? isOrdered;
  final int? reCreatingNum;
  final void Function(Problem problem)? onTapReCreate;

  const ProblemCardWidget({
    super.key,
    required this.problem,
    this.maxLines = 2,
    this.onTapReCreate,
    this.isOrdered,
    this.reCreatingNum,
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
                child: Text(
                  problem.problemType,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              if (isOrdered == true)
                GestureDetector(
                  onTap: () {
                    onTapReCreate!(problem);
                  },
                  child: Icon(
                    Icons.auto_awesome,
                    color: AppColor.primary.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
          const Gap(8),
          reCreatingNum == problem.number
              ? Center(
                child: SpinKitThreeInOut(
                  color: AppColor.primary.withValues(alpha: 0.5),
                  size: 30.0,
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${problem.number}. ${problem.question}',
                    style: AppTextStyle.labelMedium.copyWith(
                      color: AppColor.mediumGray,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  Text(
                    problem.passage,
                    style: AppTextStyle.labelMedium.copyWith(
                      color: AppColor.mediumGray,
                    ),
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
