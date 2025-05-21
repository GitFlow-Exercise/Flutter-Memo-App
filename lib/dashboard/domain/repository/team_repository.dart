import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

abstract interface class TeamRepository {
  Future<Result<List<Team>, AppException>> getTeamsByCurrentUser();

  // 현재 사용자가 속한 팀을 제외하고 모든 팀 목록 가져오기
  Future<Result<List<Team>, AppException>> getAllTeams();

  Future<Result<bool, AppException>> isUserInAnyTeam();

  Future<Result<Team, AppException>> createTeam(
    String teamName,
    String? teamImage,
  );

  Future<Result<void, AppException>> assignUserToTeam(
    String userId,
    int teamId,
  );
}
