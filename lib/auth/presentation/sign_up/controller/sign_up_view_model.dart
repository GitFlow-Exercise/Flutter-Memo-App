import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/extension/ref_extension.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  @override
  SignUpState build() {
    final emailController = TextEditingController();

    ref.onDispose(() {
      emailController.dispose();
    });

    return SignUpState(emailController: emailController);
  }

  Future<bool> checkEmail() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.isEmailExist(
      state.emailController.text,
    );

    switch (result) {
      case Success<bool, AppException>():
        return true;
      case Error<bool, AppException>():
        ref.showSnackBar(result.error.message);
        return false;
    }
  }

  Future<void> sendOtp() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = state.copyWith(hasOtpBeenSent: const AsyncLoading());
    final result = await authRepository.sendOtp(state.emailController.text);

    switch (result) {
      case Success<void, AppException>():
        state = state.copyWith(hasOtpBeenSent: const AsyncData(true));
        ref.showSnackBar('인증번호가 발송되었습니다.');
        ref.navigate(Routes.checkOtp, extra: state.emailController.text);
        return;
      case Error<void, AppException>():
        state = state.copyWith(hasOtpBeenSent: const AsyncData(false));
        ref.showSnackBar(result.error.message);
        return;
    }
  }
}
