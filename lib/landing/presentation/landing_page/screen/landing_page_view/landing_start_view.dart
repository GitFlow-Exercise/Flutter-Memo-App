import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/component/base_app_button.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/presentation/components/landing_footer.dart';

class LandingStartView extends StatelessWidget {
  const LandingStartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColor.primary),
            child: OverflowBox(
              maxHeight: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '지금 바로 Mongo AI로 문제집 만들기를 시작하세요.',
                    style: AppTextStyle.landingSubHeader.copyWith(
                      color: AppColor.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28, bottom: 36),
                    child: Text(
                      '교사의 자료 준비 시간을 획기적으로 단축하고, 다양한 학습 자료를 효율적으로 만들 수 있습니다.',
                      style: AppTextStyle.bodyRegular.copyWith(
                        color: AppColor.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BaseAppButton(
                        onTap: () {},
                        text: '무료로 시작하기',
                        bgColor: AppColor.white,
                        border: Border.all(color: AppColor.white),
                        textColor: AppColor.primary,
                      ),
                      const Gap(16),
                      BaseAppButton(
                        onTap: () {},
                        text: '데모 신청하기',
                        border: Border.all(color: AppColor.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const LandingFooter(),
      ],
    );
  }
}
