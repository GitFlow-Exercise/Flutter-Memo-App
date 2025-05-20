import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_policies_state.freezed.dart';

@freezed
abstract class PrivacyPoliciesState with _$PrivacyPoliciesState {
  const factory PrivacyPoliciesState({
    @Default(AsyncValue.data(null)) AsyncValue<dynamic> data,
  }) = _PrivacyPoliciesState;
}
