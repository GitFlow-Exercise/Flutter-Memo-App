import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_raw_text_field.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_tip_box.dart';

// 텍스트 입력 화면
class UploadInputText extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback clearTap;
  const UploadInputText({
    super.key,
    required this.controller,
    required this.clearTap,
  });

  @override
  State<UploadInputText> createState() => _UploadInputTextState();
}

class _UploadInputTextState extends State<UploadInputText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '텍스트 입력',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.mediumGray,
              ),
            ),
            InkWell(
              onTap: () {
                widget.clearTap();
                setState(() {});
              },
              child: Row(
                children: [
                  const Icon(Icons.close, color: AppColor.primary),
                  const Gap(4),
                  Text(
                    '지우기',
                    style: AppTextStyle.captionRegular.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(10),
        UploadRawTextField(
          controller: widget.controller,
          onChanged: (val) {
            setState(() {});
          },
        ),
        const Gap(16),
        const UploadTipBox(
          '최소 300자 이상의 텍스트를 입력하시면 더 다양한 문제 유형을 생성할 수 있습니다. 교과서, 논문, 기사 등의 내용을 붙여넣으세요.',
        ),
        const Gap(40),
        Row(
          children: [
            Text(
              '${widget.controller.text.length}',
              style: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary),
            ),
            Text(
              '자 입력됨 (최소 권장: 300자)',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.mediumGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
