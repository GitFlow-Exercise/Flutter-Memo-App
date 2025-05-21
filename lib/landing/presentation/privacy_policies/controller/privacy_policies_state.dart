import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/landing/domain/model/privacy_policies.dart';

part 'privacy_policies_state.freezed.dart';

@freezed
abstract class PrivacyPoliciesState with _$PrivacyPoliciesState {
  const factory PrivacyPoliciesState({
    @Default(AsyncValue.loading()) AsyncValue<PrivacyPolicies> data,
  }) = _PrivacyPoliciesState;
}
