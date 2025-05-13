import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class PasswordRequirementWidget extends StatelessWidget {
  final String text;
  final bool isMet;

  const PasswordRequirementWidget({
    super.key,
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isMet ? AppColor.primary : AppColor.lightGrayBorder,
            shape: BoxShape.circle,
          ),
          child: isMet
              ? const Icon(Icons.check, size: 10, color: AppColor.white)
              : null,
        ),
        const Gap(8),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTextStyle.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isMet ? AppColor.primary : AppColor.paleGray,
          ),
        ),
      ],
    );
  }
}