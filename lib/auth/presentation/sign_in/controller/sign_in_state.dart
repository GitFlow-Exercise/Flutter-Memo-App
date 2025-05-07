import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    @Default(false) bool isLoginRejected,
  }) = _SignInState;
}
