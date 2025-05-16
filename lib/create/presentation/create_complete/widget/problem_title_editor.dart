import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class ProblemTitleEditor extends StatelessWidget {
  final bool isEditMode;
  final String title;
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const ProblemTitleEditor({
    super.key,
    required this.isEditMode,
    required this.title,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty || isEditMode) {
      return SizedBox(
        width: 300,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '제목을 입력하세요',
            hintStyle: AppTextStyle.headingMedium.copyWith(
              color: AppColor.mediumGray,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.lightGrayBorder),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.deepBlack),
            ),
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          style: AppTextStyle.headingMedium.copyWith(color: AppColor.deepBlack),
          onSubmitted: onSubmitted,
        ),
      );
    } else {
      return Text(
        title,
        style: AppTextStyle.titleBold.copyWith(color: AppColor.deepBlack),
      );
    }
  }
}
