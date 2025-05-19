import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

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
                          Wrap(
                            children: [
                              _buildSocialIcon(Icons.facebook),
                              const SizedBox(width: 16),
                              _buildSocialIcon(Icons.web),
                              const SizedBox(width: 16),
                              _buildSocialIcon(Icons.email),
                              const SizedBox(width: 16),
                              _buildSocialIcon(Icons.chat),
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
                          _buildFooterLink('기능'),
                          const SizedBox(height: 8),
                          _buildFooterLink('요금제'),
                          const SizedBox(height: 8),
                          _buildFooterLink('로드맵'),
                          const SizedBox(height: 8),
                          _buildFooterLink('업데이트'),
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
                          _buildFooterLink('도움말 센터'),
                          const SizedBox(height: 8),
                          _buildFooterLink('튜토리얼'),
                          const SizedBox(height: 8),
                          _buildFooterLink('FAQ'),
                          const SizedBox(height: 8),
                          _buildFooterLink('문의하기'),
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
                          _buildFooterLink('소개'),
                          const SizedBox(height: 8),
                          _buildFooterLink('블로그'),
                          const SizedBox(height: 8),
                          _buildFooterLink('채용'),
                          const SizedBox(height: 8),
                          _buildFooterLink('연락처'),
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
                          _buildFooterLink('이용약관', fontSize: 14),
                          const SizedBox(width: 16),
                          _buildFooterLink('개인정보처리방침', fontSize: 14),
                          const SizedBox(width: 16),
                          _buildFooterLink('쿠키 정책', fontSize: 14),
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

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: AppColor.paleGray, size: 16),
    );
  }

  Widget _buildFooterLink(String text, {double fontSize = 16}) {
    return Text(
      text,
      style: AppTextStyle.bodyRegular.copyWith(
        color: AppColor.paleGray,
        fontSize: fontSize,
      ),
    );
  }
}
