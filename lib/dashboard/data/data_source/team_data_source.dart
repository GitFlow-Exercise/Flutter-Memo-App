import 'package:mongo_ai/dashboard/data/dto/team_dto.dart';

abstract interface class TeamDataSource {
  Future<List<TeamDto>> getTeamsByCurrentUserId();
}