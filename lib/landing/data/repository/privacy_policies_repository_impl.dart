import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/landing/data/data_source/privacy_policies_data_source.dart';
import 'package:mongo_ai/landing/data/mapper/privacy_policies_mapper.dart';
import 'package:mongo_ai/landing/domain/model/privacy_policies.dart';
import 'package:mongo_ai/landing/domain/repository/privacy_policies_repository.dart';


class PrivacyPoliciesRepositoryImpl implements PrivacyPoliciesRepository {
  final PrivacyPoliciesDataSource _privacyPoliciesDataSource;

  const PrivacyPoliciesRepositoryImpl({
    required PrivacyPoliciesDataSource privacyPoliciesDataSource,
  }) : _privacyPoliciesDataSource = privacyPoliciesDataSource;

  @override
  Future<Result<PrivacyPolicies, AppException>> getKoreanPrivacyPolicies() async {
    try {
      final dto = await _privacyPoliciesDataSource.fetchPrivacyPolicies('ko-KR');
      return Result.success(dto.toPrivacyPolicies());
    } catch (e) {
      return Result.error(
        AppException.privacyPolicies(
          message: '개인정보처리방침을 가져오는 중 문제가 발생했습니다 error: $e',
          stackTrace: StackTrace.current,
        ),
      );
    }

  }
}
