import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default(false) bool isEmailCompleted,
    @Default(false) bool isTermsOfUseChecked,
    required TextEditingController emailController,
    required TextEditingController codeController,
    required TextEditingController passwordController,
    required TextEditingController passwordConfirmController,
  }) = _SignUpState;
}
