import 'package:mongo_ai/dashboard/data/data_source/user_profile_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/user_profile_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileDataSourceImpl implements UserProfileDataSource {
  final SupabaseClient _client;

  const UserProfileDataSourceImpl({
    required SupabaseClient client,
  }) : _client = client;

  @override
  Future<UserProfileDto> getCurrentUserProfile() async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('users')
        .select()
        .eq('user_id', userId)
        .single();

    return UserProfileDto.fromJson(data);
  }
}