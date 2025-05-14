import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    @Default(AsyncValue.data(false)) AsyncValue<bool> hasOtpBeenSent,
  }) = _SignUpState;
}
