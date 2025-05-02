import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/sign_in/controller/sign_in_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_view_model.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  @override
  SignInState build() {
    return SignInState(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
    );
  }

  Future<SignInState> login() async {
    if (state.emailController.text != 'test@example.com' ||
        state.passwordController.text != 'test123456!') {
      state = state.copyWith(isLoginRejected: true);
    } else {
      state = state.copyWith(isLoginRejected: false);
    }
    return state;
  }
}
