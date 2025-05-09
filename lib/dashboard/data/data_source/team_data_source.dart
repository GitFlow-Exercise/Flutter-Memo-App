import 'package:mongo_ai/dashboard/data/dto/team_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

abstract interface class TeamDataSource {
  Future<List<TeamDto>> getTeamsByCurrentUserId();
}