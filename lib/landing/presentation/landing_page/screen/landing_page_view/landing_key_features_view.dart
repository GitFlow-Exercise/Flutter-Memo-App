import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/presentation/components/landing_feature_card.dart';
import 'package:mongo_ai/landing/presentation/landing_page/controller/landing_page_action.dart';

class LandingKeyFeaturesView extends StatelessWidget {
  final void Function(LandingPageAction action) onAction;
  const LandingKeyFeaturesView({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(32),
            Text(
              'Mongo AI 주요 기능',
              style: AppTextStyle.landingSubHeader.copyWith(
                color: AppColor.deepBlack,
              ),
            ),
            const Gap(20),
            Text(
              '교사의 자료 준비 시간을 획기적으로 단축하고, 다양한 학습 자료를 효율적으로 만들 수 있도록 도와드립니다.',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.lightGray,
              ),
            ),
            const Gap(40),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: List.generate(_icons.length, (index) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return LandingFeatureCard(
                      icon: _icons[index],
                      title: _titles[index],
                      description: _descriptions[index],
                    );
                  },
                );
              }),
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  static const List<Icon> _icons = [
    Icon(Icons.smart_toy_outlined, color: AppColor.primary, size: 40),
    Icon(Icons.drive_file_move_outline, color: AppColor.destructive, size: 40),
    Icon(Icons.web_asset_outlined, color: AppColor.circle, size: 40),
    Icon(Icons.groups_outlined, color: AppColor.secondary, size: 40),
    Icon(
      Icons.format_list_bulleted_outlined,
      color: AppColor.landingIcon,
      size: 40,
    ),
    Icon(Icons.visibility_outlined, color: AppColor.visibility, size: 40),
  ];

  static const List<String> _titles = [
    'AI 문제 생성',
    'PDF 추출',
    '맞춤형 레이아웃',
    '팀 협업',
    '체계적 관리',
    '실시간 미리보기',
  ];

  static const List<String> _descriptions = [
    '하나의 지문으로 객관식, 주관식, OX 등 다양한 유형의 문제를 자동으로 생성합니다.',
    '한 단 또는 두 단 레이아웃을 선택하여 원하는 형태의 문제집을 만들 수 있습니다.',
    '생성된 문제를 선별하여 맞춤형 PDF 문제집을 즉시 만들 수 있습니다.',
    '동료 교사들과 문제집을 공유하고 함께 작업할 수 있습니다.',
    '폴더 시스템으로 생성한 문제집을 체계적으로 관리할 수 있습니다.',
    '직관적인 단계별 프로세스와 실시간 미리보기로 사용 편의성을 극대화했습니다.',
  ];
}
