import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class CreateProblemListWidget extends StatelessWidget {
  const CreateProblemListWidget({super.key});

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
        ListView.builder(
          shrinkWrap: true,
          itemCount: 8,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
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
                      '44. 다음 중 가장 적절한 것은?',
                      style: AppTextStyle.labelMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(8),
                    Text(
                      'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
                      style: AppTextStyle.labelMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
