import 'package:mongo_ai/dashboard/data/data_source/team_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/team_dto.dart';

class MockTeamDataSourceImpl implements TeamDataSource {
  MockTeamDataSourceImpl();

  List<TeamDto> teams = [
    TeamDto(teamId: 1, teamName: 'teamName1', teamImage: 'teamImage1'),
    TeamDto(teamId: 2, teamName: 'teamName2', teamImage: 'teamImage2'),
    TeamDto(teamId: 3, teamName: 'teamName3', teamImage: 'teamImage3'),
  ];

  @override
  Future<List<TeamDto>> getTeamsByCurrentUserId() async {
    return teams;
  }

  @override
  Future<List<TeamDto>> getAllTeams() async {
    return teams;
  }

  @override
  Future<TeamDto> createTeam(String teamName, String? teamImage) async {
    final team = TeamDto(teamId: 4, teamName: teamName, teamImage: teamImage);
    teams.add(team);
    return team;
  }

  @override
  Future<void> assignUserToTeam(String userId, int teamId) async {}
}
