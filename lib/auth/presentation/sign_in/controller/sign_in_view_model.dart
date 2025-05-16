import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/domain/model/auth_state_change.dart';
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

  void Function(AuthStateChange)? _authStateChangeCallback;

  @override
  SignInState build() {
    final authRepository = ref.read(authRepositoryProvider);

    _authStateChangeCallback = handleAuthStateChange;

    authRepository.addAuthStateListener(_authStateChangeCallback!);

    ref.onDispose(() {
      if (_authStateChangeCallback != null) {
        authRepository.removeAuthStateListener(_authStateChangeCallback!);
      }
      _eventController.close();
    });

    return SignInState(
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
    );
  }

  void handleAuthStateChange(AuthStateChange change) {
    switch (change) {
      case SignedInWithGoogle(:final isFirstTimeUser):
        if (isFirstTimeUser) {
          _eventController.add(const SignInEvent.navigateToSelectTeam());
        } else {
          _eventController.add(const SignInEvent.navigateToHome());
        }
        break;
      case SignedIn():
        _eventController.add(const SignInEvent.navigateToHome());
      case SignInFailed(:final message):
        _eventController.add(SignInEvent.showSnackBar(message));
      default:
        return;
    }
  }

  // Google 로그인 시작
  Future<void> googleSignIn() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signInWithGoogle();

    if (result case Error(error: final error)) {
      _eventController.add(SignInEvent.showSnackBar(error.message));
    }
    // 성공 시 처리는 인증 상태 리스너가 처리
  }

  // 이메일 로그인
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
