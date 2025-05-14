import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class AuthFeatureItemWidget extends StatelessWidget {
  final String text;

  const AuthFeatureItemWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 2),
          child: const Icon(
            Icons.check,
            size: 20,
            color: AppColor.lighterGray,
          ),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.bodyRegular.copyWith(
              color: AppColor.lightGray,
            ),
          ),
        ),
      ],
    );
  }
}
