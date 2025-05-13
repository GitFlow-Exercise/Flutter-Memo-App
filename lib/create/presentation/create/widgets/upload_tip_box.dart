import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class UploadTipBox extends StatelessWidget {
  final String tip;
  const UploadTipBox(this.tip, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.paleBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColor.secondary),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '팁',
                  style: AppTextStyle.labelMedium.copyWith(
                    color: AppColor.mediumGray,
                  ),
                ),
                const Gap(12),
                Text(
                  tip,
                  style: AppTextStyle.captionRegular.copyWith(
                    color: AppColor.tipGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
