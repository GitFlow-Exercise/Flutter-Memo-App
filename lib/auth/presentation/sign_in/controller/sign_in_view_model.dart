import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
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
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signIn(
      state.emailController.text,
      state.passwordController.text,
    );

    switch (result) {
      case Success<void, AppException>():
        return state.copyWith(isLoginRejected: false);
      case Error<void, AppException>():
        return state.copyWith(isLoginRejected: true);
    }
  }
}
