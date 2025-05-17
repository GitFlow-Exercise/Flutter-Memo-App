import 'package:freezed_annotation/freezed_annotation.dart';

part 'landing_shell_action.freezed.dart';

@freezed
sealed class LandingShellAction with _$LandingShellAction {
  const factory LandingShellAction.onTapFreeTrial() = OnTapFreeTrial;

  const factory LandingShellAction.onTapLogo() = OnTapLogo;

  const factory LandingShellAction.onTapHome() = OnTapHome;

  const factory LandingShellAction.onTapPaymentPlans() = OnTapPaymentPlans;
}
