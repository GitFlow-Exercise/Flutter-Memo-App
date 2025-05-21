import 'package:mongo_ai/landing/data/dto/privacy_policies_dto.dart';
import 'package:mongo_ai/landing/domain/model/privacy_policies.dart';

extension PrivacyPoliciesMapper on PrivacyPoliciesDto {
  PrivacyPolicies toPrivacyPolicies() {
    return PrivacyPolicies(
      id: id?.toInt() ?? -1,
      content: content ?? '',
      language: language ?? 'ko-KR',
    );
  }
}
