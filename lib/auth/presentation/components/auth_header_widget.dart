import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 로고 원형 배경
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.primary,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/mongo_ai_logo.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
        const Gap(16),
        // 로고 텍스트
        Text(
          'Mongo AI',
          style: AppTextStyle.titleBold.copyWith(
            fontSize: 30,
            color: AppColor.deepBlack,
          ),
        ),
        const Gap(8),
        // 설명 텍스트
        Text(
          '교사를 위한 AI 기반 문제집 생성 도구',
          style: AppTextStyle.bodyRegular.copyWith(color: AppColor.lightGray),
        ),
      ],
    );
  }
}
