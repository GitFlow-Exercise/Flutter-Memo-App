import 'package:mongo_ai/landing/data/data_source/privacy_policies_data_source.dart';
import 'package:mongo_ai/landing/domain/repository/privacy_policies_repository.dart';


class PrivacyPoliciesRepositoryImpl implements PrivacyPoliciesRepository {
  final PrivacyPoliciesDataSource _privacyPoliciesDataSource;

  const PrivacyPoliciesRepositoryImpl({
    required PrivacyPoliciesDataSource privacyPoliciesDataSource,
  }) : _privacyPoliciesDataSource = privacyPoliciesDataSource;
}
