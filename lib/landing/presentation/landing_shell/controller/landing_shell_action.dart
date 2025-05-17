import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/landing/domain/enum/landing_header_menu_type.dart';

part 'landing_shell_action.freezed.dart';

@freezed
sealed class LandingShellAction with _$LandingShellAction {
  const factory LandingShellAction.onTapFreeTrial() = OnTapFreeTrial;

  const factory LandingShellAction.onTapLogo() = OnTapLogo;

  const factory LandingShellAction.onTapHome() = OnTapHome;

  const factory LandingShellAction.onTapPaymentPlans() = OnTapPaymentPlans;

  const factory LandingShellAction.onTapNavigationItem(LandingHeaderMenuType menu) = OnTapNavigationItem;
}
