import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_event.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_view_model.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  final _eventController = StreamController<SignInEvent>();

  Stream<SignInEvent> get eventStream => _eventController.stream;

  @override
  SignInState build() {
    final tempStorageRepository = ref.read(tempStorageRepositoryProvider);

    // 임시 저장 데이터 삭제
    tempStorageRepository.clearAll();

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
        _eventController.add(SignInEvent.showSnackBar(result.error.message));
        return state.copyWith(isLoginRejected: true);
    }
  }
}
