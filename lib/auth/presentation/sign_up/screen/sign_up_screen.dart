import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_state.dart';
import 'package:mongo_ai/auth/presentation/components/auth_header_widget.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class SignUpScreen extends StatefulWidget {
  final SignUpState state;
  final void Function(SignUpAction action) onAction;

  const SignUpScreen({super.key, required this.state, required this.onAction});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  bool get _isFormValid => widget.state.emailController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.state.emailController.addListener(_emailListener);
  }

  @override
  void dispose() {
    widget.state.emailController.removeListener(_emailListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AuthHeaderWidget(),

                    const Gap(30),

                    // 회원가입 카드 영역
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withAlpha(26), // 0.1 opacity
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: AppColor.black.withAlpha(26), // 0.1 opacity
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 회원가입 타이틀
                          Text(
                            '회원가입',
                            style: AppTextStyle.titleBold.copyWith(
                              color: AppColor.mediumGray,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            '이메일을 입력하여 가입을 시작하세요',
                            style: AppTextStyle.bodyRegular.copyWith(
                              color: AppColor.paleGray,
                            ),
                          ),
                          const Gap(24),

                          // 이메일 입력 폼
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이메일',
                                style: AppTextStyle.labelMedium.copyWith(
                                  color: AppColor.paleGray,
                                ),
                              ),
                              const Gap(8),
                              TextFormField(
                                onFieldSubmitted: (_) {
                                  _submitEmail();
                                },
                                controller: widget.state.emailController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    size: 16,
                                    color: AppColor.paleGray,
                                  ),
                                  hintText: 'name@example.com',
                                  hintStyle: AppTextStyle.bodyRegular.copyWith(
                                    color: AppColor.lighterGray,
                                  ),
                                  filled: true,
                                  fillColor: AppColor.lightBlue,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColor.lightGrayBorder,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColor.lightGrayBorder,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColor.primary,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                validator: _validator,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                          const Gap(24),

                          // 다음 단계 버튼
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _submitEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _isFormValid
                                        ? AppColor.primary
                                        : AppColor.lighterGray,
                                foregroundColor: AppColor.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '다음 단계',
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      color: AppColor.white,
                                    ),
                                  ),
                                  const Gap(8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                    color: AppColor.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 로그인 안내 텍스트
                    const Gap(16),
                    GestureDetector(
                      onTap:
                          () =>
                              widget.onAction(const SignUpAction.onTapSignIn()),
                      child: RichText(
                        text: TextSpan(
                          text: '이미 계정이 있으신가요? ',
                          style: AppTextStyle.captionRegular.copyWith(
                            color: AppColor.mediumGray,
                          ),
                          children: [
                            TextSpan(
                              text: '로그인',
                              style: AppTextStyle.labelMedium.copyWith(
                                color: AppColor.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.state.hasOtpBeenSent.isLoading)
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

  void _submitEmail() {
    if (_isFormValid && formKey.currentState!.validate()) {
      widget.onAction(const SignUpAction.onTapOtpSend());
    }
  }

  String? _validator(value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return '유효한 이메일 주소를 입력해주세요.';
    }
    return null;
  }

  void _emailListener() {
    setState(() {});
  }
}
