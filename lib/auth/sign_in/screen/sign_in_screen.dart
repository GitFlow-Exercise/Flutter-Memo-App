import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/sign_in/controller/sign_in_action.dart';
import 'package:mongo_ai/auth/sign_in/controller/sign_in_state.dart';
import 'package:mongo_ai/core/component/base_text_field.dart';

class SignInScreen extends StatefulWidget {
  final SignInState state;
  final void Function(SignInAction action) onAction;
  const SignInScreen({super.key, required this.state, required this.onAction});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  bool get _isFormValid =>
      widget.state.emailController.text.isNotEmpty &&
      widget.state.passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    // 이메일과 비밀번호 모두 리스너 추가
    widget.state.emailController.addListener(_onInputChanged);
    widget.state.passwordController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    // 리스너 제거
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
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 40,
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Text(
                  'LOGO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(25),
              const Text(
                '로그인',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const Gap(45),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.25,
                        child: BaseTextField(
                          hintText: '이메일 주소',
                          controller: widget.state.emailController,
                          validator: _validateEmail,
                        ),
                      ),
                      const Gap(8),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaseTextField(
                              hintText: '비밀번호',
                              controller: widget.state.passwordController,
                              isObscure: true,
                              validator: _validatePassword,
                            ),
                            if (widget.state.isLoginRejected)
                              const Text(
                                '이메일 또는 비밀번호가 올바르지 않습니다.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Gap(8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '비밀번호를 잊어버리셨나요?',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(15),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.25,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onAction(const SignInAction.onTapLogin());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid ? Colors.black : const Color(0xffBEBEBE),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('로그인'),
                ),
              ),
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('계정이 없으신가요? '),
                  GestureDetector(
                    onTap:
                        () => widget.onAction(const SignInAction.onTapSignUp()),
                    child: const Text(
                      '회원가입',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validatePassword(value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }

    return null;
  }

  String? _validateEmail(value) {
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
}
