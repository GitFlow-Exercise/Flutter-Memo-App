import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_otp_state.freezed.dart';

@freezed
abstract class CheckOtpState with _$CheckOtpState {
  const factory CheckOtpState({
    required String email,
    required TextEditingController codeController,
  }) = _CheckOtpState;
}
