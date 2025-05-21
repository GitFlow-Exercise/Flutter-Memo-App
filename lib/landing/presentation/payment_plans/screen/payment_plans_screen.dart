import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/presentation/components/faq_item.dart';
import 'package:mongo_ai/landing/presentation/components/landing_footer.dart';
import 'package:mongo_ai/landing/presentation/components/price_card.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_action.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/controller/payment_plans_state.dart';

class PaymentPlansScreen extends StatefulWidget {
  final PaymentPlansState state;
  final void Function(PaymentPlansAction action) onAction;

  const PaymentPlansScreen({
    super.key,
    required this.onAction,
    required this.state,
  });

  @override
  State<PaymentPlansScreen> createState() => _PaymentPlansScreenState();
}

class _PaymentPlansScreenState extends State<PaymentPlansScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColor.white,
        child: Column(
          children: [
            // 타이틀 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    '몽고 AI 요금제',
                    style: AppTextStyle.titleBold.copyWith(
                      fontSize: 36,
                      color: AppColor.deepBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '하나의 지문으로 여러 유형의 문제를 손쉽게 만들어내는\n교사를 위한 AI 기반 문제집 생성 도구를 확장시켜보세요',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColor.mediumGray,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // 요금제 카드 섹션
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 기본 플랜 카드
                  PriceCard(
                    title: '기본 플랜',
                    price: '무료',
                    priceSubtext: '',
                    userType: '개인 사용자용',
                    features: const [
                      '월 10개 문제 생성 제한',
                      '10개 문제집 저장 공간',
                      '기본 문제 유형 지원',
                      '기본 폴더 관리 시스템',
                    ],
                    isHighlighted: false,
                    isPremium: widget.state.isPremiumUser,
                    buttonText: !widget.state.isAuthenticated ? '시작하기' : '사용 중',
                    onButtonPressed: () {
                      if (widget.state.isAuthenticated) {
                        return;
                      }
                      widget.onAction(const PaymentPlansAction.onStartClick());
                    },
                  ),

                  const SizedBox(width: 32),

                  // 프로 플랜 카드 (하이라이트)
                  PriceCard(
                    title: '프로 플랜',
                    price: '30,000원',
                    priceSubtext: '/월',
                    userType: '전문 사용자용',
                    features: const [
                      '기본 플랜의 모든 기능 포함',
                      '무제한 이메일 전송',
                      '문서 병합 기능',
                      '무제한 사용자',
                      '무제한 문제 생성',
                      '고급 문제 유형 지원',
                      '우선 기술 지원',
                    ],
                    buttonText:
                        widget.state.isPremiumUser ? '구독 중' : '지금 업그레이드',
                    isHighlighted: true,
                    isRecommended: true,
                    isPremium: widget.state.isPremiumUser,
                    onButtonPressed: () {
                      if (widget.state.isAuthenticated &&
                          !widget.state.isPremiumUser) {
                        widget.onAction(
                          const PaymentPlansAction.onUpgradeClick(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // FAQ 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    '자주 묻는 질문',
                    style: AppTextStyle.titleBold.copyWith(
                      fontSize: 24,
                      color: AppColor.deepBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Column(
                      children: [
                        FaqItem(
                          question: '무료 플랜과 프로 플랜의 주요 차이점은 무엇인가요?',
                          answer:
                              '프로 플랜은 무제한 문제 생성, 무제한 이메일 전송, 문서 병합 기능, 무제한 사용자 등 더 많은 고급 기능을 제공합니다. 대규모 팀이나 많은 문제집을 생성해야 하는 교사에게 적합합니다.',
                        ),
                        FaqItem(
                          question: '결제는 어떻게 이루어지나요?',
                          answer:
                              '프로 플랜은 월간 또는 연간 구독으로 이용 가능합니다. 신용카드, 계좌이체 등 다양한 결제 방법을 지원합니다. 연간 결제 시 20% 할인 혜택이 적용됩니다.',
                        ),
                        FaqItem(
                          question: '언제든지 플랜을 변경할 수 있나요?',
                          answer:
                              '네, 언제든지 플랜을 업그레이드하거나 다운그레이드할 수 있습니다. 업그레이드는 즉시 적용되며, 다운그레이드는 현재 구독 기간이 끝난 후 적용됩니다.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 마지막 CTA 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '지금 바로 몽고 AI 최신 기술을 경험해보세요',
                      style: AppTextStyle.titleBold.copyWith(
                        fontSize: 24,
                        color: AppColor.deepBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '하나의 지문으로 여러 유형의 문제를 손쉽게 만들고, 맞춤형 PDF 문제집을 더욱 다양하게 활용해보세요\n프로플랜은 교사의 자료 준비 시간을 더욱 획기적으로 단축합니다.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.mediumGray,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 240,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onAction(
                            const PaymentPlansAction.onUpgradeClick(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '지금 업그레이드',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            LandingFooter(
              onPressedPrivacyPolicies: () {
                widget.onAction(
                  const PaymentPlansAction.onPressedPrivacyPolicies(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
