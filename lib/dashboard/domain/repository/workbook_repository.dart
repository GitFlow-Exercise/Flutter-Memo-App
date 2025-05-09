import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

abstract interface class WorkbookRepository {
  Future<Result<List<Workbook>, AppException>> getWorkbooksByCurrentTeamId(int teamId);
}