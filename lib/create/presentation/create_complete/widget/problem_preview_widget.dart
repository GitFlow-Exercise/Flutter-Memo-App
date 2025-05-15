import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class ProblemPreviewWidget extends StatelessWidget {
  const ProblemPreviewWidget({super.key});

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
          const Gap(24),
          Text(
            '2025년 3월 모의고사',
            style: AppTextStyle.titleBold.copyWith(color: AppColor.deepBlack),
          ),
          const Gap(24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. 다음 중 가장 적절한 것은?',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.deepBlack,
                ),
              ),
              const Gap(16),
              Text(
                'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.deepBlack,
                ),
              ),
              const Gap(24),
              Text(
                '① They may lead users to overestimate their own writing abilities\n② They are designed to improve communication speed and accuracy\n③ They encourage students to explore new ways of self-expression\n④ They provide a foundation for developing digital creativity\n⑤ They demonstrate how far AI technology has come',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.mediumGray,
                  height: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
