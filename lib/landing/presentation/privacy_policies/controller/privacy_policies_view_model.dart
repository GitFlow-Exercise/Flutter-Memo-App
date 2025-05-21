import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/landing/domain/model/privacy_policies.dart';
import 'package:mongo_ai/landing/presentation/privacy_policies/controller/privacy_policies_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privacy_policies_view_model.g.dart';

@riverpod
class PrivacyPoliciesViewModel extends _$PrivacyPoliciesViewModel {
  @override
  PrivacyPoliciesState build() {
    return const PrivacyPoliciesState();
  }

  void fetchPrivacyPolicies() async {
    state = state.copyWith(data: const AsyncLoading());
    final repository = ref.read(privacyPoliciesRepositoryProvider);
    final result = await repository.getKoreanPrivacyPolicies();

    switch (result) {
      case Success<PrivacyPolicies, AppException>():
        state = state.copyWith(data: AsyncValue.data(result.data));
      case Error<PrivacyPolicies, AppException>():
        state = state.copyWith(
          data: AsyncValue.error(
            result.error,
            result.error.stackTrace ?? StackTrace.empty,
          ),
        );
    }
  }
}
