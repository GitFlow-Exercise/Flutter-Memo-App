import 'package:mongo_ai/dashboard/domain/model/team.dart';

abstract interface class TeamDataSource {
  Future<List<Team>> getTeamsByCurrentUser();
}