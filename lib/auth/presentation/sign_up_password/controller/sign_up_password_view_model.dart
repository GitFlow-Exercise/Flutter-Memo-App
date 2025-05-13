import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/domain/model/password_criteria.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_event.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/controller/sign_up_password_state.dart';
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

  // 임시 사용자 관련 로직 전체 삭제
}
