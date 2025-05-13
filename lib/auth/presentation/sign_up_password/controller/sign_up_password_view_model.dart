import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mongo_ai/auth/domain/model/temp_user.dart';
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
  Future<SignUpPasswordState> build(String tempStoreId) async {
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
      tempStoreId: tempStoreId,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
    );
  }

  // UI 관련 토글 함수들
  void togglePasswordVisibility() {
    state = state.whenData(
      (value) => value.copyWith(isPasswordVisible: !value.isPasswordVisible),
    );
  }

  void toggleConfirmPasswordVisibility() {
    state = state.whenData(
      (value) => value.copyWith(
        isConfirmPasswordVisible: !value.isConfirmPasswordVisible,
      ),
    );
  }

  void togglePrivacyPolicy() {
    state = state.whenData(
      (value) => value.copyWith(checkPrivacyPolicy: !value.checkPrivacyPolicy),
    );
    _validateForm();
  }

  // 유효성 검사 로직
  void _validatePassword() {
    final currentState = state.value;
    if (currentState == null) return;

    final password = currentState.passwordController.text;
    final criteria = _evaluatePasswordStrength(password);

    state = state.whenData(
      (value) => value.copyWith(meetsPasswordCriteria: criteria),
    );
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
    final currentState = state.value;
    if (currentState == null) return;

    final isValid = _checkFormValidity(currentState);
    state = state.whenData((value) => value.copyWith(isFormValid: isValid));
  }

  bool _checkFormValidity(SignUpPasswordState currentState) {
    final password = currentState.passwordController.text;
    final confirmPassword = currentState.confirmPasswordController.text;
    final hasMinLength = currentState.meetsPasswordCriteria.contains(
      PasswordCriteria.minLength,
    );

    return hasMinLength &&
        password == confirmPassword &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        currentState.checkPrivacyPolicy;
  }

  // 임시 사용자 관련 로직
  Future<void> sendOtp() async {
    final tempStoreId = state.value?.tempStoreId ?? '';
    final password = state.value?.passwordController.text;

    // 임시 사용자 정보 확인
    final tempUser = _getTempUser(tempStoreId);
    if (tempUser == null || password == null) {
      _eventController.add(
        const SignUpPasswordEvent.showSnackBar('알 수 없는 오류가 발생했습니다.'),
      );
      return;
    }

    // 임시 사용자 비밀번호 업데이트
    final newTempStoreId = _updateTempUserPassword(tempStoreId, password);
    if (newTempStoreId == null) {
      _eventController.add(
        const SignUpPasswordEvent.showSnackBar('알 수 없는 오류가 발생했습니다.'),
      );
      return;
    }

    // OTP 전송 시도
    await _sendOtpToUser(tempUser.email, newTempStoreId);
  }

  Future<void> _sendOtpToUser(String email, String tempStoreId) async {
    state = state.whenData((value) => value.copyWith(hasOtpBeenSent: const AsyncLoading()));

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.sendOtp(email);

    switch (result) {
      case Success<void, AppException>():
        state = state.whenData((value) => value.copyWith(hasOtpBeenSent: const AsyncData(true)));
        _eventController.add(
          const SignUpPasswordEvent.showSnackBar('인증번호가 발송되었습니다.'),
        );
        _eventController.add(
          SignUpPasswordEvent.navigateToVerifyOtp(tempStoreId),
        );
        return;
      case Error<void, AppException>():
        state = state.whenData((value) => value.copyWith(hasOtpBeenSent: const AsyncData(false)));
        _eventController.add(
          SignUpPasswordEvent.showSnackBar(result.error.message),
        );
        return;
    }
  }

  String? _updateTempUserPassword(String id, String password) {
    final repository = ref.read(tempStorageRepositoryProvider);
    final result = repository.retrieveData(id);

    if (result is Success<TempUser, AppException>) {
      final updated = result.data.copyWith(password: password);
      return repository.storeData(updated);
    }
    return null;
  }

  TempUser? _getTempUser(String id) {
    final repository = ref.read(tempStorageRepositoryProvider);
    final result = repository.retrieveData(id);

    if (result is Success<TempUser, AppException>) {
      return result.data;
    }
    return null;
  }
}
