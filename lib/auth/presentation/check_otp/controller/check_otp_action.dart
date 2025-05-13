import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_otp_action.freezed.dart';

@freezed
sealed class CheckOtpAction with _$CheckOtpAction {
  const factory CheckOtpAction.onTap() = OnTap;
}