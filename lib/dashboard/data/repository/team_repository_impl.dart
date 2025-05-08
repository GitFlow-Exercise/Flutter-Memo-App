

import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/data_source/team_data_source.dart';
import 'package:mongo_ai/dashboard/data/mapper/team_mapper.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/domain/repository/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamDataSource _dataSource;

  const TeamRepositoryImpl({
    required TeamDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<List<Team>, AppException>> getTeamsByCurrentUser() async {
    try {
      final teamDtos = await _dataSource.getTeamsByCurrentUser();
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
}