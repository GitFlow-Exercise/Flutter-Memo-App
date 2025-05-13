import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/auth/domain/model/password_criteria.dart';

part 'sign_up_password_state.freezed.dart';

@freezed
abstract class SignUpPasswordState with _$SignUpPasswordState {
  const factory SignUpPasswordState({
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
