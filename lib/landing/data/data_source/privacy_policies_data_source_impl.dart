import 'package:mongo_ai/core/constants/app_table_name.dart';
import 'package:mongo_ai/landing/data/data_source/privacy_policies_data_source.dart';
import 'package:mongo_ai/landing/data/dto/privacy_policies_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrivacyPoliciesDataSourceImpl implements PrivacyPoliciesDataSource {
  final SupabaseClient _client;

  const PrivacyPoliciesDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<PrivacyPoliciesDto> fetchPrivacyPolicies(String language) async {
    final data =
        await _client
            .from(AppTableName.privacyPolicies)
            .select()
            .eq('language', language)
            .single();

    return PrivacyPoliciesDto.fromJson(data);
  }
}
