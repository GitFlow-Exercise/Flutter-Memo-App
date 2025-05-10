import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/data_source/workbook_data_source.dart';
import 'package:mongo_ai/dashboard/data/mapper/workbook_mapper.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/domain/repository/workbook_repository.dart';

class WorkbookRepositoryImpl implements WorkbookRepository {
  final WorkbookDataSource _dataSource;

  const WorkbookRepositoryImpl({
    required WorkbookDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<List<Workbook>, AppException>> getWorkbooksByCurrentTeamId(int teamId) async {
    try {
      final workbookDtos = await _dataSource.getWorkbooksByCurrentTeamId(teamId);
      final workbooks = workbookDtos.map((e) => e.toWorkbook()).toList();
      return Result.success(workbooks);
    } catch(e) {
      return Result.error(
        AppException.remoteDataBase(
          message: '문제집 정보를 가져오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}