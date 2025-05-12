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

    passwordController.addListener(() => _validatePassword());
    confirmPasswordController.addListener(() => _validateForm());

    ref.onDispose(() {
      _eventController.close();
      passwordController.dispose();
      confirmPasswordController.dispose();
    });

    return SignUpPasswordState(
      tempStoreId: tempStoreId,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
    );
  }

  // 비밀번호 보기/숨기기 토글
  void togglePasswordVisibility() {
    state = state.whenData((value) =>
        value.copyWith(isPasswordVisible: !value.isPasswordVisible)
    );
  }

  // 비밀번호 확인 보기/숨기기 토글
  void toggleConfirmPasswordVisibility() {
    state = state.whenData((value) =>
        value.copyWith(isConfirmPasswordVisible: !value.isConfirmPasswordVisible)
    );
  }

  // 개인정보처리방침 및 이용약관 동의 토글
  void togglePrivacyPolicy() {
    state = state.whenData((value) =>
        value.copyWith(checkPrivacyPolicy: !value.checkPrivacyPolicy)
    );
    _validateForm();
  }

  // 비밀번호 유효성 검사
  void _validatePassword() {
    final pState = state.value;
    if (pState == null) return;

    final password = pState.passwordController.text;
    final Set<PasswordCriteria> criteria = {};

    // 비밀번호 길이 검사 (8자 이상)
    if (password.length >= 8) {
      criteria.add(PasswordCriteria.minLength);
    }

    // 대문자 포함 검사
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      criteria.add(PasswordCriteria.includesUppercase);
    }

    // 소문자 포함 검사
    if (RegExp(r'[a-z]').hasMatch(password)) {
      criteria.add(PasswordCriteria.includesLowercase);
    }

    // 숫자 포함 검사
    if (RegExp(r'[0-9]').hasMatch(password)) {
      criteria.add(PasswordCriteria.includesNumber);
    }

    state = state.whenData((value) =>
        value.copyWith(meetsPasswordCriteria: criteria)
    );
    _validateForm();
  }

  // 전체 폼 유효성 검사
  void _validateForm() {
    final pState = state.value;
    if (pState == null) return;

    final password = pState.passwordController.text;
    final confirmPassword = pState.confirmPasswordController.text;
    final hasMinLength = pState.meetsPasswordCriteria.contains(PasswordCriteria.minLength);

    // 폼이 유효하려면:
    // 1. 비밀번호는 최소 8자 이상 (필수 조건)
    // 2. 비밀번호와 확인이 일치해야 함
    // 3. 개인정보처리방침 및 이용약관에 동의해야 함
    final isValid = hasMinLength &&
        password == confirmPassword &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        pState.checkPrivacyPolicy;

    state = state.whenData((value) =>
        value.copyWith(isFormValid: isValid)
    );
  }

  // 회원가입 시도
  //TODO: tempStorage 다 수정해야함
  Future<bool> successSendOtp() async {
    final authRepository = ref.read(authRepositoryProvider);
    final tempStorageRepository = ref.read(tempStorageRepositoryProvider);

    final tempStoreResult = tempStorageRepository.retrieveData(state.value?.tempStoreId ?? '');

    TempUser tempUser;

    switch (tempStoreResult) {
      case Success<TempUser, AppException>():
        tempUser = tempStoreResult.data.copyWith(password: state.value?.passwordController.text ?? '');
      case Error<TempUser, AppException>():
        _eventController.add(SignUpPasswordEvent.showSnackBar(tempStoreResult.error.message));
        return false;
    }

    final tempStoreId = tempStorageRepository.storeData(tempUser);

    final result = await authRepository.sendOtp(tempUser.email);

    switch (result) {
      case Success<void, AppException>():
        _eventController.add(const SignUpPasswordEvent.showSnackBar('인증번호가 발송되었습니다.'));
        _eventController.add(SignUpPasswordEvent.navigateToVerifyOtp(tempStoreId));
        return true;
      case Error<void, AppException>():
        _eventController.add(SignUpPasswordEvent.showSnackBar(result.error.message));
        return false;
    }
  }
}