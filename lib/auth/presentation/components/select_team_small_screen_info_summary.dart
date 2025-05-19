import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class SmallScreenInfoSummary extends StatelessWidget {
  const SmallScreenInfoSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.blue.withValues(alpha: 0.8),
            ),
            const Gap(8),
            const Text(
              '팀 설정 안내',
              style: TextStyle(
                fontFamily: AppTextStyle.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.mediumGray,
              ),
            ),
          ],
        ),
        const Gap(12),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.people_outline,
              size: 16,
              color: AppColor.primary,
            ),
            Gap(8),
            Expanded(
              child: Text(
                '팀원들과 문제집을 공유하고 함께 작업할 수 있습니다.',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightGray,
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 16,
              color: AppColor.primary,
            ),
            Gap(8),
            Expanded(
              child: Text(
                '체계적인 폴더 시스템으로 자료를 효율적으로 관리하세요.',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightGray,
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.update,
              size: 16,
              color: AppColor.primary,
            ),
            Gap(8),
            Expanded(
              child: Text(
                '팀원들과 실시간으로 의견을 나누고 피드백을 주고받을 수 있습니다.',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightGray,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 16,
              color: Colors.amber.withValues(alpha: 0.8),
            ),
            const Gap(8),
            const Expanded(
              child: Text(
                '팀은 언제든지 변경하거나 새로 만들 수 있습니다.',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.paleGray,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}