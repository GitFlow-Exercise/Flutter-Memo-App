// team_repository_impl.dart
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/data_source/team_data_source.dart';
import 'package:mongo_ai/dashboard/data/mapper/team_mapper.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/repository/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamDataSource _dataSource;

  const TeamRepositoryImpl({required TeamDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<List<Team>, AppException>> getTeamsByCurrentUser() async {
    try {
      final teamDtos = await _dataSource.getTeamsByCurrentUserId();
      final teams = teamDtos.map((e) => e.toTeam()).toList();
      return Result.success(teams);
    } catch (e) {
      return Result.error(
        AppException.remoteDataBase(
          message: '팀 정보를 가져오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<List<Team>, AppException>> getAllTeams() async {
    try {
      final teamDtos = await _dataSource.getAllTeams();
      final teams = teamDtos.map((e) => e.toTeam()).toList();
      return Result.success(teams);
    } catch (e) {
      print(e);
      return Result.error(
        AppException.remoteDataBase(
          message: '팀 목록을 가져오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<Team, AppException>> createTeam(
    String teamName,
    String? teamImage,
  ) async {
    try {
      final teamDto = await _dataSource.createTeam(teamName, teamImage);
      final team = teamDto.toTeam();
      return Result.success(team);
    } catch (e) {
      return Result.error(
        AppException.remoteDataBase(
          message: '팀 생성 중 오류가 발생했습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> assignUserToTeam(
    String userId,
    int teamId,
    String role,
  ) async {
    try {
      await _dataSource.assignUserToTeam(userId, teamId, role);
      return const Result.success(null);
    } catch (e) {
      return Result.error(
        AppException.remoteDataBase(
          message: '사용자를 팀에 할당하는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}
