// team_data_source_impl.dart
import 'package:mongo_ai/dashboard/data/data_source/team_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/team_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamDataSourceImpl implements TeamDataSource {
  final SupabaseClient _client;

  const TeamDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<List<TeamDto>> getTeamsByCurrentUserId() async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('team_users_expand_view')
        .select('team_id, team_name, team_image')
        .eq('user_id', userId);

    return data.map((e) => TeamDto.fromJson(e)).toList();
  }

  @override
  Future<List<TeamDto>> getAllTeams() async {
    final result = await _client
        .rpc('get_non_joined_teams', params: {
      'user_uuid': _client.auth.currentUser!.id
    });

    final List<dynamic> data = result;
    return data.map((e) => TeamDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<TeamDto> createTeam(String teamName, String? teamImage) async {
    final data =
        await _client
            .from('team')
            .insert({
              'team_name': teamName,
              'team_image': teamImage,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();

    return TeamDto.fromJson(data);
  }

  @override
  Future<void> assignUserToTeam(String userId, int teamId) async {
    await _client.from('team_users').insert({
      'user_id': userId,
      'team_id': teamId,
    });
  }
}
