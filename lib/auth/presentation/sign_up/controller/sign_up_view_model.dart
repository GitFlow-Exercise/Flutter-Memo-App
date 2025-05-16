import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_event.dart';
import 'package:mongo_ai/auth/presentation/sign_up/controller/sign_up_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  final _eventController = StreamController<SignUpEvent>();

  Stream<SignUpEvent> get eventStream => _eventController.stream;

  @override
  SignUpState build() {
    final emailController = TextEditingController();
    final codeController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordConfirmController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      emailController.dispose();
      codeController.dispose();
      passwordController.dispose();
      passwordConfirmController.dispose();
    });

    return SignUpState(
      emailController: emailController,
      codeController: codeController,
      passwordController: passwordController,
      passwordConfirmController: passwordConfirmController,
    );
  }

  set isEmailCompleted(bool isEmailCompleted) {
    state = state.copyWith(isEmailCompleted: isEmailCompleted);
  }

  void toggleTermsOfUse() {
    state = state.copyWith(isTermsOfUseChecked: !state.isTermsOfUseChecked);
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
        _eventController.add(SignUpEvent.showSnackBar(result.error.message));
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
        _eventController.add(const SignUpEvent.showSnackBar('인증번호가 발송되었습니다.'));
        _eventController.add(SignUpEvent.navigateToCheckOtp(state.emailController.text));
        return;
      case Error<void, AppException>():
        state = state.copyWith(hasOtpBeenSent: const AsyncData(false));
        _eventController.add(SignUpEvent.showSnackBar(result.error.message));
        return;
    }
  }

  //TODO(ok): 추후 화면 구현 시 이동 예정
  Future<bool> signUp() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signUp(
      state.emailController.text,
      state.passwordController.text,
    );

    switch (result) {
      case Success<void, AppException>():
        return true;
      case Error<void, AppException>():
        _eventController.add(SignUpEvent.showSnackBar(result.error.message));
        return false;
    }
  }

  //TODO(ok): 추후 화면 구현 시 이동 예정
  Future<bool> saveUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.saveUser();
    switch (result) {
      case Success<void, AppException>():
        return true;
      case Error<void, AppException>():
        _eventController.add(SignUpEvent.showSnackBar(result.error.message));
        return false;
    }
  }

  //TODO(ok): 추후 화면 구현 시 이동 예정
  Future<bool> verifyOtp() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.verifyEmailOtp(
      state.emailController.text,
      state.codeController.text,
    );

    switch (result) {
      case Success<void, AppException>():
        return true;
      case Error<void, AppException>():
        _eventController.add(SignUpEvent.showSnackBar(result.error.message));
        return false;
    }
  }

  //TODO(ok): 추후 화면 구현 시 이동 예정
  Future<bool> resetPassword() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.resetPassword(
      state.passwordController.text,
    );

    switch (result) {
      case Success<void, AppException>():
        return true;
      case Error<void, AppException>():
        _eventController.add(SignUpEvent.showSnackBar(result.error.message));
        return false;
    }
  }
}
