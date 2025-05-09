import 'package:mongo_ai/dashboard/data/data_source/team_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/team_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamDataSourceImpl implements TeamDataSource {
  final SupabaseClient _client;

  const TeamDataSourceImpl({
    required SupabaseClient client,
  }) : _client = client;

  @override
  Future<List<TeamDto>> getTeamsByCurrentUserId() async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('team_users_expand_view')
        .select('team_id, team_name, team_image')
        .eq('user_id', userId);

    return data
        .map((e) => TeamDto.fromJson(e))
        .toList();
  }
}