import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_plans_action.freezed.dart';

@freezed
sealed class PaymentPlansAction with _$PaymentPlansAction {
  const factory PaymentPlansAction.onStartClick() = OnStartClick;

  const factory PaymentPlansAction.onUpgradeClick() = OnUpgradeClick;

  const factory PaymentPlansAction.onFreeTrialClick() = OnFreeTrialClick;
}
