import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_action.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_state.dart';
import 'package:mongo_ai/core/component/base_text_field.dart';

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
    widget.state.emailController.addListener(() {
      setState(() {}); // 이메일 입력값이 변경될 때마다 화면 갱신
    });
  }

  @override
  void dispose() {
    widget.state.emailController.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: widget.state.emailController,
                    validator: _validator,
                  ),
                ),
                const Gap(20),
                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      widget.onAction(const SignUpAction.onTapStart());
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    padding: const EdgeInsets.symmetric(vertical: 12.5),
                    decoration: BoxDecoration(
                      color:
                          _isFormValid
                              ? Colors.black
                              : Colors.grey, // 값 입력 여부에 따라 색상 변경
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
                    TextButton(
                      onPressed:
                          () =>
                              widget.onAction(const SignUpAction.onTapSignIn()),
                      child: const Text('로그인'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
}
