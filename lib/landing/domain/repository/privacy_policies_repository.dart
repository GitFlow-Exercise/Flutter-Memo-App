import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/landing/domain/model/privacy_policies.dart';

abstract interface class PrivacyPoliciesRepository {
  Future<Result<PrivacyPolicies, AppException>> getKoreanPrivacyPolicies();
}
