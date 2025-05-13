import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:mongo_ai/auth/presentation/sign_up_complete/controller/sign_up_complete_action.dart';
import 'package:mongo_ai/core/component/auth_feature_item_widget.dart';
import 'package:mongo_ai/core/component/auth_header_widget.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class SignUpCompleteScreen extends StatefulWidget {
  final void Function(SignUpCompleteAction action) onAction;

  const SignUpCompleteScreen({super.key, required this.onAction});

  @override
  State<SignUpCompleteScreen> createState() => _SignUpCompleteScreenState();
}

class _SignUpCompleteScreenState extends State<SignUpCompleteScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBlue,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(60),
              // 로고 및 제목 영역
              const AuthHeaderWidget(),

              const Gap(40),

              // 메인 카드 영역
              Container(
                width: 448,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Lottie.asset(
                        'lottie/check_lottie.json',
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..forward();
                        },
                        fit: BoxFit.fill,
                        width: 104,
                        height: 104,
                      ),
                    ),

                    const Gap(24),

                    // 회원가입 완료 텍스트
                    Text(
                      '회원가입 완료!',
                      style: AppTextStyle.titleBold.copyWith(
                        fontSize: 24,
                        color: AppColor.mediumGray,
                      ),
                    ),

                    const Gap(16),

                    // 안내 메시지
                    Text(
                      'Mongo AI에 오신 것을 환영합니다.\n이제 AI 기반 문제집 생성을 시작할 수 있습니다.',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyRegular.copyWith(
                        color: AppColor.lightGray,
                        height: 1.375,
                      ),
                    ),

                    const Gap(32),

                    // 기능 소개 영역
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mongo AI로 할 수 있는 일:',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.mediumGray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Gap(16),

                          // 기능 리스트
                          const AuthFeatureItemWidget(
                            text: '텍스트, 이미지, PDF에서 문제 자동 생성',
                          ),
                          const Gap(12),
                          const AuthFeatureItemWidget(
                            text: '맞춤형 PDF 문제집 즉시 제작',
                          ),
                          const Gap(12),
                          const AuthFeatureItemWidget(text: '팀 협업 및 문제집 공유'),
                        ],
                      ),
                    ),

                    const Gap(40),

                    // 대시보드 이동 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            () => widget.onAction(
                              const SignUpCompleteAction.onTapHome(),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          foregroundColor: AppColor.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '대시보드로 이동',
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                            const Gap(8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppColor.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(60),
            ],
          ),
        ),
      ),
    );
  }
}
