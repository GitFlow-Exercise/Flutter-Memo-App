import 'package:freezed_annotation/freezed_annotation.dart';

part 'landing_page_action.freezed.dart';

@freezed
sealed class LandingPageAction with _$LandingPageAction {
  const factory LandingPageAction.goToSignIn() = GoToSignIn;

  const factory LandingPageAction.onPressedPrivacyPolicies() = OnPressedPrivacyPolicies;
}
