import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:memo_app/core/component/base_text_field.dart';

class PasswordSignupScreen extends StatefulWidget {
  const PasswordSignupScreen({super.key});

  @override
  State<PasswordSignupScreen> createState() => _PasswordSignupScreenState();
}

class _PasswordSignupScreenState extends State<PasswordSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isChecked = false;

  bool get _isFormValid {
    return _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _isChecked;
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
                  controller: _passwordController,
                  hintText: '비밀번호를 입력해주세요.',
                  isObscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    final passwordRegex = RegExp(
                      r'^(?=.*[a-z])(?=.*[!@#\$&*~]).{9,}$',
                    );
                    if (!passwordRegex.hasMatch(value)) {
                      return '소문자와 특수문자를 포함해주세요.';
                    }
                    return null;
                  },
                ),
              ),
              const Gap(16),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.25,
                child: BaseTextField(
                  controller: _confirmPasswordController,
                  hintText: '비밀번호 확인',
                  isObscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호 확인을 입력해주세요.';
                    }
                    if (value != _passwordController.text) {
                      return '비밀번호가 서로 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
              ),
              const Gap(16),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.25,
                child: Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
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
                child: ElevatedButton(
                  onPressed:
                      _isFormValid
                          ? () {
                            if (_formKey.currentState!.validate()) {
                              // 유효성 검사가 통과되었을 때 실행할 코드
                              print('비밀번호 설정 완료');
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
}
