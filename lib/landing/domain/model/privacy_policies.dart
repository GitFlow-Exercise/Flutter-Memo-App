import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_policies.freezed.dart';

@freezed
abstract class PrivacyPolicies with _$PrivacyPolicies {
  const factory PrivacyPolicies({
    required int id,
    required String content,
    required String language,
  }) = _PrivacyPolicies;
}