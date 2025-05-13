import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create/widgets/upload_raw_text_field.dart';

// 텍스트 입력 화면
class UploadInputText extends StatelessWidget {
  final TextEditingController controller;
  const UploadInputText({super.key, required this.controller});

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
        UploadRawTextField(controller: controller),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: AppColor.paleBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColor.secondary),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '팁',
                      style: AppTextStyle.labelMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                    const Gap(12),
                    Text(
                      '최소 300자 이상의 텍스트를 입력하시면 더 다양한 문제 유형을 생성할 수 있습니다. 교과서, 논문, 기사 등의 내용을 붙여넣으세요.',
                      style: AppTextStyle.captionRegular.copyWith(
                        color: AppColor.tipGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
