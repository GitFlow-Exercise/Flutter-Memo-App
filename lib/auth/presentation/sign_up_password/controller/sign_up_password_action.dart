import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_password_action.freezed.dart';

@freezed
sealed class SignUpPasswordAction with _$SignUpPasswordAction {
  const factory SignUpPasswordAction.onTap() = OnTap;
}