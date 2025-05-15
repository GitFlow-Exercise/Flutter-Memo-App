import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_state.dart';

class ProblemPreviewWidget extends StatelessWidget {
  final String title;
  final List<CompleteProblem> problems;
  const ProblemPreviewWidget({
    super.key,
    required this.problems,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 650,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.lightGrayBorder),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyle.titleBold.copyWith(color: AppColor.deepBlack),
          ),
          const Gap(24),
          ...problems.map((problem) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                Text(
                  problem.question,
                  style: AppTextStyle.labelMedium.copyWith(
                    color: AppColor.deepBlack,
                  ),
                ),
                const Gap(16),
                Text(
                  problem.content,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.deepBlack,
                  ),
                ),
                const Gap(24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      problem.options.map((option) {
                        return Text(
                          option,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.mediumGray,
                            height: 2,
                          ),
                        );
                      }).toList(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
