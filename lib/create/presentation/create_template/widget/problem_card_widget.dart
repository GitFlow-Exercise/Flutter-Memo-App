import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

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
