import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState({
    required TextEditingController emailController,
    @Default(AsyncValue.data(false)) AsyncValue<bool> hasOtpBeenSent,
  }) = _SignUpState;
}
