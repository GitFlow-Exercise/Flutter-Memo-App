import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class LandingCreateStateCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;
  const LandingCreateStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.white,
        border: Border.all(color: AppColor.lightGrayBorder),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyle.titleBold.copyWith(color: AppColor.deepBlack),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: icon,
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
