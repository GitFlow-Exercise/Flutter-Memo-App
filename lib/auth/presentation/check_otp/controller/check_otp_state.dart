import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_otp_state.freezed.dart';

@freezed
abstract class CheckOtpState with _$CheckOtpState {
  const factory CheckOtpState({
    required TextEditingController codeController,
    @Default(AsyncValue.data(false)) AsyncValue<bool> isOtpVerified,
    required String email,
    @Default(300) int remainingSeconds, // 5분(300초) 기본값
    String? errorMessage,
  }) = _CheckOtpState;
}
