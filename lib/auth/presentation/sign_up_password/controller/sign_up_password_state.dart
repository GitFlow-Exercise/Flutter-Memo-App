import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_password_state.freezed.dart';

@freezed
abstract class SignUpPasswordState with _$SignUpPasswordState {
  const factory SignUpPasswordState({
    required String email,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    @Default(false) bool checkPrivacyPolicy,
  }) = _SignUpPasswordState;
}