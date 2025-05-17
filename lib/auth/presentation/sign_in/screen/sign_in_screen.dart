import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/presentation/components/auth_header_widget.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_action.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_state.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/core/utils/validators.dart';

class SignInScreen extends StatefulWidget {
  final SignInState state;
  final void Function(SignInAction action) onAction;

  const SignInScreen({super.key, required this.state, required this.onAction});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.state.emailController.addListener(_onInputChanged);
    widget.state.passwordController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    widget.state.emailController.removeListener(_onInputChanged);
    widget.state.passwordController.removeListener(_onInputChanged);
    super.dispose();
  }

  void _onInputChanged() {
    setState(() {}); // 입력값이 변경될 때마다 화면 갱신
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(32),

            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthHeaderWidget(),

                  const Gap(40),

                  // 로그인 카드
                  Container(
                    width: 420,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withValues(alpha: 0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: AppColor.black.withValues(alpha: 0.1),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 로그인 텍스트
                        Center(
                          child: Text(
                            '로그인',
                            style: AppTextStyle.titleBold.copyWith(
                              fontSize: 24,
                              color: AppColor.deepBlack,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Center(
                          child: Text(
                            '계정에 로그인하여 Mongo AI를 시작하세요',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.lightGray,
                            ),
                          ),
                        ),
                        const Gap(32),

                        // 이메일 입력
                        Text(
                          '이메일',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          controller: widget.state.emailController,
                          onFieldSubmitted: (_) {
                            _submitForm();
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email,
                              size: 16,
                              color: AppColor.paleGray,
                            ),
                            hintText: 'name@example.com',
                            hintStyle: AppTextStyle.labelMedium.copyWith(
                              color: AppColor.paleGray,
                            ),
                            fillColor: AppColor.lightBlue,
                            filled: true,
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
                              borderSide: const BorderSide(color: AppColor.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.destructive,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.destructive,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: Validators.validateEmail,
                        ),
                        const Gap(24),

                        // 비밀번호 입력
                        Text(
                          '비밀번호',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          controller: widget.state.passwordController,
                          onFieldSubmitted: (_) {
                            _submitForm();
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 16,
                              color: AppColor.paleGray,
                            ),
                            hintText: '••••••••',
                            hintStyle: AppTextStyle.labelMedium.copyWith(
                              color: AppColor.paleGray,
                            ),
                            fillColor: AppColor.lightBlue,
                            filled: true,
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
                              borderSide: const BorderSide(color: AppColor.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.destructive,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColor.destructive,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: Validators.validatePassword,
                        ),
                        const Gap(16),

                        // 로그인 버튼
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                widget.state.isFormValid
                                    ? AppColor.primary
                                    : AppColor.paleGray,
                            disabledBackgroundColor: AppColor.lighterGray,
                            foregroundColor: AppColor.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('로그인', style: AppTextStyle.bodyMedium),
                              Gap(8),
                              Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),

                        const Gap(16),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColor.lightGrayBorder,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '또는',
                                style: TextStyle(
                                  fontFamily: AppTextStyle.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.paleGray,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColor.lightGrayBorder,
                              ),
                            ),
                          ],
                        ),

                        const Gap(16),

                        ElevatedButton(
                          onPressed: () {
                            widget.onAction(const SignInAction.onTapGoogleSingIn());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.white,
                            foregroundColor: AppColor.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(width: 40, height: 40, child: Image.asset('images/google_logo.png', width: 40, height: 40,)),
                              ),
                              const Gap(10),
                              Text('Sign in with Google', style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: AppColor.black, fontSize: 16))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),

                  // 회원가입 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '계정이 없으신가요? ',
                        style: AppTextStyle.captionRegular.copyWith(
                          color: AppColor.paleGray,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => widget.onAction(const SignInAction.onTapSignUp()),
                        child: Text(
                          '회원가입',
                          style: AppTextStyle.captionRegular.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Gap(32),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (widget.state.isFormValid && _formKey.currentState?.validate() == true) {
      widget.onAction(const SignInAction.onTapLogin());
    }
  }
}
