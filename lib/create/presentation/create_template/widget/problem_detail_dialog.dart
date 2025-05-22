import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/domain/model/problem.dart';

class ProblemDetailDialog extends StatelessWidget {
  final Problem problem;

  const ProblemDetailDialog({super.key, required this.problem});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 750,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(24),
            Text(
              '${problem.number}. ${problem.question}',
              style: AppTextStyle.bodyMedium,
            ),
            const Gap(12),
            Text(problem.passage, style: AppTextStyle.bodyMedium),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  problem.options.asMap().entries.map((e) {
                    return Column(
                      children: [
                        Text(
                          '${e.key + 1}. ${e.value}',
                          style: AppTextStyle.bodyMedium,
                        ),
                        const Gap(8),
                      ],
                    );
                  }).toList(),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
