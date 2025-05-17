import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_plans_state.freezed.dart';

@freezed
abstract class PaymentPlansState with _$PaymentPlansState {
  const factory PaymentPlansState({
    @Default(AsyncValue.data(null)) AsyncValue<dynamic> data,
  }) = _PaymentPlansState;
}