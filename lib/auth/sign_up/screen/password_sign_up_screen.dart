import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/sign_up/controller/sign_up_action.dart';
import 'package:mongo_ai/auth/sign_up/controller/sign_up_state.dart';
import 'package:mongo_ai/core/component/base_text_field.dart';

class PasswordSignupScreen extends StatefulWidget {
  final SignUpState state;
  final void Function(SignUpAction action) onAction;
  const PasswordSignupScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<PasswordSignupScreen> createState() => _PasswordSignupScreenState();
}

class _PasswordSignupScreenState extends State<PasswordSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  bool get _isFormValid {
    return widget.state.passwordController.text.isNotEmpty &&
        widget.state.passwordConfirmController.text.isNotEmpty &&
        widget.state.isTermsOfUseChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.2,
                height: 40,
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Text(
                  'LOGO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(30),
              const Text(
                '안전한 비밀번호는 계정을\n보호하는 첫걸음이에요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const Gap(30),
              const Text(
                '이렇게 설정하시면 계정이 해킹으로부터 훨씬 더 안전해질거에요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Gap(8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '• 9자 이상 ',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Gap(4),
                  Text(
                    '• 소문자 1개 이상 포함 ',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Gap(4),
                  Text(
                    '• 특수 문자 1개 이상 포함',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const Gap(24),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.25,
                child: BaseTextField(
                  controller: widget.state.passwordController,
                  hintText: '비밀번호를 입력해주세요.',
                  isObscure: true,
                  validator: _validatePassword,
                ),
              ),
              const Gap(16),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.25,
                child: BaseTextField(
                  controller: widget.state.passwordConfirmController,
                  hintText: '비밀번호 확인',
                  isObscure: true,
                  validator: _validatePasswordConfirm,
                ),
              ),
              const Gap(16),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.25,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: widget.state.isTermsOfUseChecked,
                      onChanged: (value) {
                        widget.onAction(const SignUpAction.onTapTermsOfUse());
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          text: '몽고의 ',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(
                              text: '서비스 이용약관',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '과 '),
                            TextSpan(
                              text: '개인정보 처리방침',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  '에 동의하며,\n마케팅 정보 수신에 동의합니다. 마케팅 수신은 언제든지\n해지할 수 있습니다.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.25,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      _isFormValid
                          ? () {
                            if (_formKey.currentState!.validate()) {
                              widget.onAction(const SignUpAction.onTapSignUp());
                            }
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid ? Colors.black : const Color(0xffBEBEBE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('회원가입하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validatePasswordConfirm(value) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요.';
    }
    if (value != widget.state.passwordController.text) {
      return '비밀번호가 서로 일치하지 않습니다.';
    }
    return null;
  }

  String? _validatePassword(value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[!@#\$&*~]).{9,}$');
    if (!passwordRegex.hasMatch(value)) {
      return '소문자와 특수문자를 포함해주세요.';
    }
    return null;
  }
}
