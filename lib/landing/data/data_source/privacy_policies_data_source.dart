import 'package:mongo_ai/landing/data/dto/privacy_policies_dto.dart';

abstract interface class PrivacyPoliciesDataSource {
  Future<PrivacyPoliciesDto> fetchPrivacyPolicies(String language);
}
