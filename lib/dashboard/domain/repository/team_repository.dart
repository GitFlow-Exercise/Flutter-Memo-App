import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';

abstract interface class TeamRepository {
  Future<Result<List<Team>, AppException>>  getTeamsByCurrentUser();
}