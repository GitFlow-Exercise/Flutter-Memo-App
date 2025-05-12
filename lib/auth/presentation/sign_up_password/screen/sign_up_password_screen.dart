import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class SignUpPasswordScreen extends StatefulWidget {
  final AsyncValue<SignUpPasswordState> state;
  final void Function(SignUpPasswordAction action) onAction;

  const SignUpPasswordScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.state.when(
      data: (state) => _buildContent(context, state),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
    );
  }

  Widget _buildContent(BuildContext context, SignUpPasswordState state) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(60),
                  // 로고 영역
                  Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            'images/mongo_ai_logo.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Text(
                        'Mongo AI',
                        style: AppTextStyle.titleBold.copyWith(
                          color: AppColor.deepBlack,
                          fontSize: 30,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        '교사를 위한 AI 기반 문제집 생성 도구',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.lightGray,
                        ),
                      ),
                    ],
                  ),
                  const Gap(40),
                  // 비밀번호 설정 카드
                  Container(
                    width: 448,
                    padding: const EdgeInsets.all(24),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목
                        const Center(
                          child: Text('비밀번호 설정', style: AppTextStyle.titleBold),
                        ),
                        const Gap(8),
                        Center(
                          child: Text(
                            '안전한 비밀번호를 설정하여 계정을 완성하세요',
                            style: AppTextStyle.bodyRegular.copyWith(
                              color: AppColor.lighterGray,
                            ),
                          ),
                        ),
                        const Gap(32),

                        // 비밀번호 입력 필드
                        Text(
                          '비밀번호',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          controller: state.passwordController,
                          obscureText: !state.isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 16,
                              color: AppColor.paleGray,
                            ),
                            hintText: '비밀번호 입력',
                            hintStyle: const TextStyle(
                              fontFamily: AppTextStyle.fontFamily,
                              fontSize: 16,
                              color: AppColor.lighterGray,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.lightGrayBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.lightGrayBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.primary,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.paleGray,
                                size: 20,
                              ),
                              onPressed:
                                  () => widget.onAction(
                                    const SignUpPasswordAction.onTapShowPassword(),
                                  ),
                            ),
                          ),
                        ),
                        const Gap(24),

                        // 비밀번호 확인 필드
                        Text(
                          '비밀번호 확인',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          controller: state.confirmPasswordController,
                          obscureText: !state.isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 16,
                              color: AppColor.paleGray,
                            ),
                            hintText: '비밀번호 재입력',
                            hintStyle: const TextStyle(
                              fontFamily: AppTextStyle.fontFamily,
                              fontSize: 16,
                              color: AppColor.lighterGray,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAFAFA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.lightGrayBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.lightGrayBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.primary,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isConfirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.paleGray,
                                size: 20,
                              ),
                              onPressed:
                                  () => widget.onAction(
                                    const SignUpPasswordAction.onTapShowConfirmPassword(),
                                  ),
                            ),
                          ),
                        ),
                        const Gap(24),

                        // 비밀번호 강도 표시
                        const Text(
                          '비밀번호 강도',
                          style: AppTextStyle.captionRegular,
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            for (int i = 0; i < 4; i++)
                              Expanded(
                                child: Container(
                                  height: 4,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: _getPasswordStrengthColor(state, i),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Gap(16),

                        // 비밀번호 요구사항
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPasswordRequirement(
                              state,
                              '최소 8자 이상(필수)',
                              PasswordCriteria.minLength,
                            ),
                            const Gap(8),
                            _buildPasswordRequirement(
                              state,
                              '대문자 포함',
                              PasswordCriteria.includesUppercase,
                            ),
                            const Gap(8),
                            _buildPasswordRequirement(
                              state,
                              '소문자 포함',
                              PasswordCriteria.includesLowercase,
                            ),
                            const Gap(8),
                            _buildPasswordRequirement(
                              state,
                              '숫자 포함',
                              PasswordCriteria.includesNumber,
                            ),
                          ],
                        ),
                        const Gap(24),

                        // 약관 동의
                        Row(
                          children: [
                            Checkbox(
                              value: state.checkPrivacyPolicy,
                              activeColor: AppColor.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged:
                                  (_) => widget.onAction(
                                    const SignUpPasswordAction.onTapCheckPrivacyPolicy(),
                                  ),
                            ),
                            const Expanded(
                              child: Text(
                                'Mongo AI의 개인정보처리방침 및 이용약관에 동의합니다.',
                                style: TextStyle(
                                  fontFamily: AppTextStyle.fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(24),

                        // 회원가입 완료 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed:
                                state.isFormValid
                                    ? () => widget.onAction(
                                      const SignUpPasswordAction.onTapSendOtp(),
                                    )
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  state.isFormValid
                                      ? AppColor.primary
                                      : AppColor.lighterGray,
                              foregroundColor: AppColor.white,
                              disabledBackgroundColor: AppColor.lighterGray,
                              disabledForegroundColor: AppColor.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('다음', style: AppTextStyle.bodyMedium),
                                Gap(8),
                                Icon(Icons.arrow_forward, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // 로그인 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이미 계정이 있으신가요?',
                        style: AppTextStyle.captionRegular.copyWith(
                          color: AppColor.paleGray,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () => widget.onAction(
                              const SignUpPasswordAction.onTapLogin(),
                            ),
                        child: Text(
                          '로그인',
                          style: AppTextStyle.captionRegular.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Gap(60),
                ],
              ),
            ),
          ),
          if (widget.state.value?.isLoading ?? false)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              width: double.infinity,
              height: double.infinity,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // 비밀번호 요구사항 항목 위젯
  Widget _buildPasswordRequirement(
    SignUpPasswordState state,
    String text,
    PasswordCriteria criteria,
  ) {
    final isMet = state.meetsPasswordCriteria.contains(criteria);
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isMet ? AppColor.primary : AppColor.lightGrayBorder,
            shape: BoxShape.circle,
          ),
          child:
              isMet
                  ? const Icon(Icons.check, size: 10, color: AppColor.white)
                  : null,
        ),
        const Gap(8),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTextStyle.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isMet ? AppColor.primary : AppColor.paleGray,
          ),
        ),
      ],
    );
  }

  // 비밀번호 강도에 따른 색상
  Color _getPasswordStrengthColor(SignUpPasswordState state, int index) {
    final strength = state.meetsPasswordCriteria.length;
    if (strength > index) {
      switch (strength) {
        case 1:
          return AppColor.destructive;
        case 2:
          return AppColor.primary.withValues(alpha: 0.3);
        case 3:
          return AppColor.primary.withValues(alpha: 0.7);
        case 4:
          return AppColor.primary;
        default:
          return AppColor.lightGrayBorder;
      }
    }
    return AppColor.lightGrayBorder;
  }
}
