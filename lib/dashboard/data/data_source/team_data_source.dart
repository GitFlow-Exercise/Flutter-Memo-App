// team_data_source.dart
import 'package:mongo_ai/dashboard/data/dto/team_dto.dart';

abstract interface class TeamDataSource {
  Future<List<TeamDto>> getTeamsByCurrentUserId();

  Future<List<TeamDto>> getAllTeams();

  Future<TeamDto> createTeam(String teamName, String? teamImage);

  Future<void> assignUserToTeam(String userId, int teamId, String role);
}
