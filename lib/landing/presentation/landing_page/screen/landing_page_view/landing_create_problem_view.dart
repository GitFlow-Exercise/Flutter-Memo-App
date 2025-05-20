import 'package:flutter/material.dart';
import 'package:mongo_ai/core/component/base_app_button.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/presentation/components/landing_create_stage_card.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/landing/presentation/landing_page/controller/landing_page_action.dart';

class LandingCreateProblemView extends StatelessWidget {
  final void Function(LandingPageAction action) onAction;
  const LandingCreateProblemView({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: double.infinity,
      child: Container(
        color: AppColor.lightBlue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '간단한 3단계로 문제집 생성',
              style: AppTextStyle.landingSubHeader.copyWith(
                color: AppColor.deepBlack,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 40),
              child: Text(
                'Mongo AI는 직관적인 프로세스로 누구나 쉽게 문제집을 만들 수 있습니다.',
                style: AppTextStyle.bodyRegular.copyWith(
                  color: AppColor.lightGray,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  return LandingCreateStateCard(
                    icon: _icons[index],
                    title: _titles[index],
                    description: _descriptions[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Gap(24);
                },
              ),
            ),
            const Gap(40),
            BaseAppButton(
              onTap: () {
                onAction(const LandingPageAction.goToSignIn());
              },
              text: '무료로 시작하기',
            ),
          ],
        ),
      ),
    );
  }

  static const List<Icon> _icons = [
    Icon(Icons.download_outlined, color: AppColor.primary, size: 40),
    Icon(Icons.edit_outlined, color: AppColor.primary, size: 40),
    Icon(Icons.picture_as_pdf_outlined, color: AppColor.primary, size: 40),
  ];

  static const List<String> _titles = ['콘텐츠 업로드', 'AI 문제 생성', '문제집 추출'];

  static const List<String> _descriptions = [
    '텍스트를 입력하거나 PDF, 이미지 파일을 업로드하세요.',
    'AI가 다양한 유형의 문제를 자동으로 생성합니다.',
    '원하는 문제를 선택하고 PDF로 다운로드하세요.',
  ];
}
