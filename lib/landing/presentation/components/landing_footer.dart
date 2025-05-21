import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/presentation/components/landing_footer_social_icon.dart';

class LandingFooter extends StatelessWidget {
  final VoidCallback onPressedPrivacyPolicies;

  const LandingFooter({super.key, required this.onPressedPrivacyPolicies});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: AppColor.deepBlack,
      padding: const EdgeInsets.only(top: 64, bottom: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 메뉴 영역
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mongo AI',
                            style: AppTextStyle.titleBold.copyWith(
                              color: AppColor.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'AI 기반 문제집 생성 도구',
                            style: AppTextStyle.bodyRegular.copyWith(
                              color: AppColor.paleGray,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Wrap(
                            children: [
                              LandingFooterSocialIcon(icon: Icons.facebook),
                              SizedBox(width: 16),
                              LandingFooterSocialIcon(icon: Icons.web),
                              SizedBox(width: 16),
                              LandingFooterSocialIcon(icon: Icons.email),
                              SizedBox(width: 16),
                              LandingFooterSocialIcon(icon: Icons.chat),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '제품',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const LandingFooterLinkButton(text: '기능'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: '요금제'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: '로드맵'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: '업데이트'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '지원',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const LandingFooterLinkButton(text: '도움말 센터'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: '튜토리얼'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: 'FAQ'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: '문의하기'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '회사',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const LandingFooterLinkButton(text: '소개'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: '블로그'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: '채용'),
                          const SizedBox(height: 8),
                          const LandingFooterLinkButton(text: '연락처'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 64),

              // 하단 저작권 영역
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Container(
                  padding: const EdgeInsets.only(top: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFF374151), width: 1),
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2025 Mongo AI. All rights reserved.',
                        style: AppTextStyle.captionRegular.copyWith(
                          color: AppColor.paleGray,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          const LandingFooterLinkButton(text: '이용약관', fontSize: 14),
                          const SizedBox(width: 16),
                          LandingFooterLinkButton(
                            onPressed: onPressedPrivacyPolicies,
                            text: '개인정보처리방침',
                            fontSize: 14,
                          ),
                          const SizedBox(width: 16),
                          const LandingFooterLinkButton(text: '쿠키 정책', fontSize: 14),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LandingFooterLinkButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final VoidCallback? onPressed;

  const LandingFooterLinkButton({
    super.key,
    required this.text,
    this.onPressed,
    double? fontSize,
  }) : fontSize = fontSize ?? 16;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTextStyle.bodyRegular.copyWith(
          color: AppColor.paleGray,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
