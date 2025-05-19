import 'package:mongo_ai/dashboard/data/dto/team_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

extension TeamMapper on TeamDto {
  Team toTeam() {
    return Team(
      teamId: (teamId ?? 0).toInt(),
      teamName: teamName ?? '',
      teamImage: teamImage,
    );
  }
}