import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_action.freezed.dart';

@freezed
sealed class SignInAction with _$SignInAction {
  const factory SignInAction.onTapLogin() = OnTapLogin;
  const factory SignInAction.onTapForgotPassword() = OnTapForgotPassword;
  const factory SignInAction.onTapSignUp() = OnTapSignUp;
}
