import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class ProblemQuestionEditor extends StatelessWidget {
  final bool isEditMode;
  final TextEditingController controller;
  final String question;
  final ValueChanged<String> onChanged;

  const ProblemQuestionEditor({
    super.key,
    required this.isEditMode,
    required this.controller,
    required this.question,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isEditMode
        ? TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '문제를 입력하세요',
            hintStyle: AppTextStyle.labelMedium.copyWith(
              color: AppColor.mediumGray,
            ),
            border: const OutlineInputBorder(),
          ),
          style: AppTextStyle.labelMedium.copyWith(color: AppColor.deepBlack),
          onChanged: onChanged,
          maxLines: null,
        )
        : Text(
          question,
          style: AppTextStyle.labelMedium.copyWith(color: AppColor.deepBlack),
        );
  }
}
