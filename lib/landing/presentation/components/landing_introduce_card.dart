import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class LandingIntroduceCard extends StatelessWidget {
  final Icon icon;
  final String text;
  const LandingIntroduceCard({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          icon,
          const Gap(16),
          Text(
            text,
            style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mediumGray),
          ),
        ],
      ),
    );
  }
}
