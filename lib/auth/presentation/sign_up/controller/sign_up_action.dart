import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_action.freezed.dart';

@freezed
sealed class SignUpAction with _$SignUpAction {
  const factory SignUpAction.onTapSignIn() = OnTapSignIn;

  const factory SignUpAction.onTapOtpSend() = OnTapOtpSend;
}
