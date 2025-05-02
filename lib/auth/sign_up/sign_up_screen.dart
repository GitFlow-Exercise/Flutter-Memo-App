import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_app/core/component/base_text_field.dart';
import 'package:memo_app/core/routing/routes.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          color: Colors.white,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 40,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: const Text(
                    'LOGO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(35),
                const Text(
                  '무료로 시작해보세요.\n바로 2시간 돌려드릴게요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                const Gap(35),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: BaseTextField(
                    hintText: '이메일 주소를 입력해주세요',
                    validator: (value) {
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
                    },
                    controller: emailController,
                  ),
                ),

                const Gap(20),
                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      context.go(Routes.signUpPassword);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    padding: const EdgeInsets.symmetric(vertical: 12.5),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      '이메일로 시작하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('이미 계정이 있으신가요?'),
                    TextButton(onPressed: () {}, child: const Text('로그인')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
