import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class LandingFeatureCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;
  const LandingFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.white,
        border: Border.all(color: AppColor.lightGrayBorder),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.paleGrayBorder,
            ),
            child: icon,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              title,
              style: AppTextStyle.titleBold.copyWith(color: AppColor.deepBlack),
            ),
          ),
          Text(
            description,
            style: AppTextStyle.bodyRegular.copyWith(color: AppColor.lightGray),
          ),
        ],
      ),
    );
  }
}
