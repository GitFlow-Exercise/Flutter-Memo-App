import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_view_dto.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

abstract interface class WorkbookRepository {
  Future<Result<List<Workbook>, AppException>> getWorkbooksByCurrentTeamId(int teamId);
  Future<Result<Workbook, AppException>> createWorkbook(WorkbookTableDto workbookTableDto);
  Future<Result<Workbook, AppException>> updateWorkbook(Workbook workbook);
  Future<Result<Workbook, AppException>> deleteWorkbook(Workbook workbook);
  Future<Result<int, AppException>> bookmarkWorkbookList(List<Workbook> workbookList, bool bookmark);
  Future<Result<int, AppException>> changeFolderWorkbookList(List<Workbook> workbookList, int folderId);
  Future<Result<int, AppException>> moveTrashWorkbookList(List<Workbook> workbookList);
  Future<Result<int, AppException>> deleteWorkbookList(List<Workbook> workbookList);
}