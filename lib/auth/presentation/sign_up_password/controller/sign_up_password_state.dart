import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_password_state.freezed.dart';

@freezed
abstract class SignUpPasswordState with _$SignUpPasswordState {
  const factory SignUpPasswordState({
    required String tempStoreId,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    @Default(false) bool checkPrivacyPolicy,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isConfirmPasswordVisible,
    @Default({}) Set<PasswordCriteria> meetsPasswordCriteria,
    @Default(false) bool isFormValid,
    @Default(AsyncValue.data(false)) AsyncValue<bool> hasOtpBeenSent,
  }) = _SignUpPasswordState;
}

enum PasswordCriteria {
  minLength, // 최소 8자 이상
  includesUppercase, // 대문자 포함
  includesLowercase, // 소문자 포함
  includesNumber, // 숫자 포함
}
