import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/domain/model/auth_state_change.dart';
import 'package:mongo_ai/auth/presentation/sign_in/controller/sign_in_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/event/app_event.dart';
import 'package:mongo_ai/core/event/app_event_provider.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_view_model.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  void Function(AuthStateChange)? _authStateChangeCallback;

  @override
  SignInState build() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authRepository = ref.read(authRepositoryProvider);

    _authStateChangeCallback = handleAuthStateChange;

    authRepository.addAuthStateListener(_authStateChangeCallback!);

    ref.onDispose(() {
      if (_authStateChangeCallback != null) {
        authRepository.removeAuthStateListener(_authStateChangeCallback!);
      }
      emailController.dispose();
      passwordController.dispose();
    });

    return SignInState(
      emailController: emailController,
      passwordController: passwordController,
    );
  }

  void handleAuthStateChange(AuthStateChange change) {
    switch (change) {
      case SignedInWithGoogle(:final hasTeamNotSelected):
        if (hasTeamNotSelected) {
          _navigate(Routes.selectTeam);
        } else {
          _navigate(Routes.folder);
        }
        break;
      case SignedIn():
        _navigate(Routes.folder);
      case SignInFailed(:final message):
        _readySnackBar(message);
      default:
        return;
    }
  }

  // Google 로그인 시작
  Future<void> googleSignIn() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signInWithGoogle();

    if (result case Error(error: final error)) {
      _readySnackBar(error.message);
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
        _readySnackBar(result.error.message);
        return state.copyWith(isLoginRejected: true);
    }
  }

  void _readySnackBar(String message) {
    ref
        .read(appEventProvider.notifier)
        .addEvent(AppEventState.showSnackBar(message: message));
  }

  void _navigate(String routeName) {
    ref
        .read(appEventProvider.notifier)
        .addEvent(AppEventState.navigate(routeName: routeName));
  }
}
