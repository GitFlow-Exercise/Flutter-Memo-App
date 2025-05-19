import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/data_source/workbook_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_view_dto.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';
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

  @override
  Future<Result<Workbook, AppException>> createWorkbook(WorkbookTableDto workbookTemplate) async {
    try {
      final workbookDto = await _dataSource.createWorkbook(workbookTemplate);
      final workbook = workbookDto.toWorkbook();
      return Result.success(workbook);
    } catch (e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '문제집 생성 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<Workbook, AppException>> updateWorkbook(Workbook workbook) async {
    try {
      final workbookTableDto = workbook.toWorkbookTableDto();
      await _dataSource.updateWorkbook(workbookTableDto);
      return Result.success(workbook);
    } catch (e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '문제집 수정 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<int, AppException>> bookmarkWorkbookList(List<Workbook> workbookList, bool bookmark) async {
    if(workbookList.isEmpty) {
      return const Result.success(0);
    }
    try {
      final workbookIds = workbookList.map((workbook) => workbook.workbookId).toList();
      await _dataSource.updateWorkbookList(
        workbookIds: workbookIds,
        fields: {'bookmark': bookmark},
      );
      return Result.success(workbookList.length);
    } catch(e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '문제집 북마크 수정 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<int, AppException>> changeFolderWorkbookList(List<Workbook> workbookList, int folderId) async {
    if(workbookList.isEmpty) {
      return const Result.success(0);
    }
    try {
      final workbookIds = workbookList.map((workbook) => workbook.workbookId).toList();
      await _dataSource.updateWorkbookList(
        workbookIds: workbookIds,
        fields: {'folder_id': folderId},
      );
      return Result.success(workbookList.length);
    } catch(e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '문제집 폴더 이동 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<int, AppException>> moveTrashWorkbookList(List<Workbook> workbookList) async {
    if(workbookList.isEmpty) {
      return const Result.success(0);
    }
    try {
      final workbookIds = workbookList.map((workbook) => workbook.workbookId).toList();
      await _dataSource.updateWorkbookList(
        workbookIds: workbookIds,
        fields: {'deleted_at': DateTime.now().toIso8601String()},
      );
      return Result.success(workbookList.length);
    } catch(e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '문제집 휴지통 이동 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<Workbook, AppException>> deleteWorkbook(Workbook workbook) async {
    try {
      await _dataSource.deleteWorkbook(workbook.workbookId);
      return Result.success(workbook);
    } catch (e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '문제집 삭제 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<int, AppException>> deleteWorkbookList(List<Workbook> workbookList) async {
    if(workbookList.isEmpty) {
      return const Result.success(0);
    }
    try {
      final workbookIds = workbookList.map((w) => w.workbookId).toList();
      await _dataSource.deleteWorkbookList(workbookIds);
      return Result.success(workbookList.length);
    } catch (e, st) {
      return Result.error(
        AppException.remoteDataBase(
          message: '문제집 일괄 삭제 중 오류가 발생했습니다.',
          error: e,
          stackTrace: st,
        ),
      );
    }
  }
}