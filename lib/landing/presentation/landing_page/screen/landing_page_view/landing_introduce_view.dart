import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/component/base_app_button.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/presentation/components/landing_introduce_card.dart';

class LandingIntroduceView extends StatelessWidget {
  const LandingIntroduceView({super.key});

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: double.infinity,
      child: Container(
        color: AppColor.paleGrayBorder,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: '하나의 지문으로 ',
                  style: AppTextStyle.landingHeader,
                  children: [
                    TextSpan(
                      text: '다양한 문제',
                      style: AppTextStyle.landingHeader.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                    const TextSpan(text: '를\n손쉽게 만들어보세요'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(40),
              Text(
                'Mongo AI는 교사를 위한 AI 기반 문제집 생성 도구입니다. 텍스트, 이미지, PDF에서 콘텐츠를\n추출하여 다양한 유형의 문제를 자동 생성합니다.',
                style: AppTextStyle.headingMedium.copyWith(
                  color: AppColor.lightGray,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(80),
              SizedBox(
                height: 128,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    return LandingIntroduceCard(
                      icon: _icons[index],
                      text: _texts[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(24);
                  },
                ),
              ),
              const Gap(48),
              BaseAppButton(
                onTap: () {
                  context.push(Routes.signIn);
                },
                text: '무료료 시작하기',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const List<Icon> _icons = [
    Icon(Icons.edit, color: AppColor.primary, size: 40),
    Icon(Icons.picture_as_pdf_outlined, color: AppColor.destructive, size: 40),
    Icon(Icons.web_asset_outlined, color: AppColor.circle, size: 40),
    Icon(Icons.groups_outlined, color: AppColor.secondary, size: 40),
  ];

  static const List<String> _texts = ['AI 자동 생성', 'PDF 추출', '다양한 레이아웃', '팀 협업'];
}
