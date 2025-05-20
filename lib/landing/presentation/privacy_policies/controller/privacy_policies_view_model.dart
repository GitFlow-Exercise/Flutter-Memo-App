import 'package:mongo_ai/landing/presentation/privacy_policies/controller/privacy_policies_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privacy_policies_view_model.g.dart';

@riverpod
class PrivacyPoliciesViewModel extends _$PrivacyPoliciesViewModel {
  @override
  PrivacyPoliciesState build() {
    return const PrivacyPoliciesState();
  }
}