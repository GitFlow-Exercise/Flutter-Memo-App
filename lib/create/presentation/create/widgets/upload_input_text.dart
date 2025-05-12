import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_raw_text_field.dart';

// 텍스트 입력 화면
class UploadInputText extends StatelessWidget {
  final void Function(String) onChanged;
  final TextEditingController controller;
  const UploadInputText({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '텍스트 입력',
          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.mediumGray),
        ),
        const Gap(10),
        UploadRawTextField(onChanged: onChanged, controller: controller),
      ],
    );
  }
}
