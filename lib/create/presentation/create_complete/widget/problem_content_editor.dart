import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class ProblemContentEditor extends StatelessWidget {
  final bool isEditMode;
  final TextEditingController controller;
  final String content;
  final ValueChanged<String> onChanged;

  const ProblemContentEditor({
    super.key,
    required this.isEditMode,
    required this.controller,
    required this.content,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isEditMode
        ? TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '문제 내용을 입력하세요',
            hintStyle: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.mediumGray,
            ),
            border: const OutlineInputBorder(),
          ),
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.deepBlack),
          onChanged: onChanged,
          maxLines: null,
        )
        : Text(
          content,
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.deepBlack),
        );
  }
}
