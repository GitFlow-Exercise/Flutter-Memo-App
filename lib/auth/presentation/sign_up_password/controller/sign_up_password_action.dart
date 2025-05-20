import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_password_action.freezed.dart';

@freezed
sealed class SignUpPasswordAction with _$SignUpPasswordAction {
  const factory SignUpPasswordAction.submitForm() = SubmitForm;

  const factory SignUpPasswordAction.onTapCheckPrivacyPolicy() =
      OnTapCheckPrivacyPolicy;

  const factory SignUpPasswordAction.onTapShowPassword() = OnTapShowPassword;

  const factory SignUpPasswordAction.onTapShowConfirmPassword() =
      OnTapShowConfirmPassword;

  const factory SignUpPasswordAction.onTapLogin() = OnTapLogin;

  const factory SignUpPasswordAction.onPressedPrivacyPolicies() = OnPressedPrivacyPolicies;
}
