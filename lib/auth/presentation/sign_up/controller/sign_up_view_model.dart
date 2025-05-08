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
    return SignUpState(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      passwordConfirmController: TextEditingController(),
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

  Future<void> saveUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.saveUser();
  }
}
