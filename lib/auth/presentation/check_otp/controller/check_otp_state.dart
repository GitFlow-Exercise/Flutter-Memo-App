import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_otp_state.freezed.dart';

@freezed
abstract class CheckOtpState with _$CheckOtpState {
  const factory CheckOtpState({
    required String tempUserId,
    required TextEditingController codeController,
    @Default(false) bool isVerifying,
    @Default('') String maskedEmail,
    @Default(300) int remainingSeconds, // 5분(300초) 기본값
    String? errorMessage,
  }) = _CheckOtpState;
}