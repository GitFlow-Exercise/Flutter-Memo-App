import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/domain/model/password_criteria.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_event.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_state.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_password_view_model.g.dart';

@riverpod
class SignUpPasswordViewModel extends _$SignUpPasswordViewModel {
  final _eventController = StreamController<SignUpPasswordEvent>();

  Stream<SignUpPasswordEvent> get eventStream => _eventController.stream;

  @override
  SignUpPasswordState build() {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    ref.onDispose(() {
      _eventController.close();
      passwordController.dispose();
      confirmPasswordController.dispose();
    });

    passwordController.addListener(() => _validatePassword());
    confirmPasswordController.addListener(() => _validateForm());

    return SignUpPasswordState(
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
    );
  }

  // UI 관련 토글 함수들
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  void togglePrivacyPolicy() {
    state = state.copyWith(checkPrivacyPolicy: !state.checkPrivacyPolicy);
    _validateForm();
  }

  // 유효성 검사 로직
  void _validatePassword() {
    final password = state.passwordController.text;
    final criteria = _evaluatePasswordStrength(password);

    state = state.copyWith(meetsPasswordCriteria: criteria);
    _validateForm();
  }

  Set<PasswordCriteria> _evaluatePasswordStrength(String password) {
    final criteria = <PasswordCriteria>{};

    if (password.length >= 8) {
      criteria.add(PasswordCriteria.minLength);
    }

    if (RegExp(r'[A-Z]').hasMatch(password)) {
      criteria.add(PasswordCriteria.includesUppercase);
    }

    if (RegExp(r'[a-z]').hasMatch(password)) {
      criteria.add(PasswordCriteria.includesLowercase);
    }

    if (RegExp(r'[0-9]').hasMatch(password)) {
      criteria.add(PasswordCriteria.includesNumber);
    }

    return criteria;
  }

  void _validateForm() {
    final isValid = _checkFormValidity();
    state = state.copyWith(isFormValid: isValid);
  }

  bool _checkFormValidity() {
    final password = state.passwordController.text;
    final confirmPassword = state.confirmPasswordController.text;
    final hasMinLength = state.meetsPasswordCriteria.contains(
      PasswordCriteria.minLength,
    );

    return hasMinLength &&
        password == confirmPassword &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        state.checkPrivacyPolicy;
  }

  // 회원가입 로직 추가
  Future<void> submitForm() async {
    if (!state.isFormValid) {
      _eventController.add(
        const SignUpPasswordEvent.showSnackBar('입력 정보를 확인해주세요.'),
      );
      return;
    }

    // 로딩 상태로 변경
    state = state.copyWith(
      hasSignUpInfoBeenSent: const AsyncValue.loading(),
    );

    try {
      // 현재 사용자 이메일 가져오기
      final authRepository = ref.read(authRepositoryProvider);
      final emailResult = await authRepository.getCurrentUserEmail();

      switch (emailResult) {
        case Success(data: final email):
        // 회원가입 요청
          final signUpResult = await authRepository.signUp(
            email,
            state.passwordController.text,
          );

          switch (signUpResult) {
            case Success():
            // 회원가입 성공 후 사용자 정보 저장
              final saveUserResult = await authRepository.saveUser();

              switch (saveUserResult) {
                case Success():
                // 사용자 정보 저장 성공, 완료 화면으로 이동
                  state = state.copyWith(
                    hasSignUpInfoBeenSent: const AsyncValue.data(true),
                  );
                  _eventController.add(
                    const SignUpPasswordEvent.navigateToComplete(),
                  );
                  return;
                case Error(error: final saveError):
                // 사용자 정보 저장 실패
                  state = state.copyWith(
                    hasSignUpInfoBeenSent: const AsyncValue.data(false),
                  );
                  _eventController.add(
                    SignUpPasswordEvent.showSnackBar(saveError.message),
                  );
                  return;
              }
            case Error(error: final error):
            // 회원가입 실패 처리
              state = state.copyWith(
                hasSignUpInfoBeenSent: const AsyncValue.data(false),
              );
              _eventController.add(
                SignUpPasswordEvent.showSnackBar(error.message),
              );
              return;
          }
        case Error(error: final error):
        // 이메일 가져오기 실패 처리
          state = state.copyWith(
            hasSignUpInfoBeenSent: const AsyncValue.data(false),
          );
          _eventController.add(
            SignUpPasswordEvent.showSnackBar(error.message),
          );
          return;
      }
    } catch (e) {
      // 예외 처리
      state = state.copyWith(
        hasSignUpInfoBeenSent: const AsyncValue.data(false),
      );
      _eventController.add(
        const SignUpPasswordEvent.showSnackBar('알 수 없는 오류가 발생했습니다.'),
      );
    }
  }
}