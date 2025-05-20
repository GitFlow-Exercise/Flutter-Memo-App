import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_plans_event.freezed.dart';

@freezed
sealed class PaymentPlansEvent with _$PaymentPlansEvent {
  const factory PaymentPlansEvent.showToast(String message) = ShowToast;
}
