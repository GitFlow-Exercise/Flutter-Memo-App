import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_otp_state.freezed.dart';

@freezed
abstract class CheckOtpState with _$CheckOtpState {
  const factory CheckOtpState({
    @Default(AsyncValue.data(null)) AsyncValue<dynamic> data,
  }) = _CheckOtpState;
}
