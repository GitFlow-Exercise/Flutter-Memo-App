import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/create_complete_params.dart';

part 'payment_plans_state.freezed.dart';

@freezed
abstract class PaymentPlansState with _$PaymentPlansState {
  const factory PaymentPlansState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isPremiumUser,
    CreateCompleteParams? params,
  }) = _PaymentPlansState;
}
