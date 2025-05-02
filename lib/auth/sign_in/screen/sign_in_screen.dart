import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
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
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: '이메일 주소',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          validator: _validateEmail,
                        ),
                      ),
                      const Gap(8),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.25,
                        child: ValueListenableBuilder<String?>(
                          valueListenable: errorNotifier,
                          builder: (context, errorText, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    focusColor: Colors.black,
                                    hintText: '비밀번호',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '비밀번호를 입력해주세요.';
                                    }
                                    return null;
                                  },
                                ),
                                if (errorText != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      errorText,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
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
                    if (formKey.currentState!.validate()) {
                      // 유효성 검사가 통과되었을 때 실행할 코드
                      final email = emailController.text;
                      final password = passwordController.text;

                      // 예시: 이메일 또는 비밀번호가 잘못된 경우
                      if (email != 'test@example.com' ||
                          password != 'password123') {
                        errorNotifier.value = '이메일 또는 비밀번호가 올바르지 않습니다';
                      } else {
                        errorNotifier.value = null;
                        print('로그인 성공');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffBEBEBE),
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
              const Text.rich(
                TextSpan(
                  text: '계정이 없으신가요? ',
                  style: TextStyle(fontSize: 12),
                  children: [
                    TextSpan(
                      text: '회원가입',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
