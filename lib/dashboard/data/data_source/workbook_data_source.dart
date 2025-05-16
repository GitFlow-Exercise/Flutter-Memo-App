import 'package:mongo_ai/dashboard/data/dto/workbook_view_dto.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';

abstract interface class WorkbookDataSource {
  Future<List<WorkbookViewDto>> getWorkbooksByCurrentTeamId(int teamId);
  Future<WorkbookViewDto> createWorkbook(WorkbookTableDto workbookTableDto);
  Future<void> updateWorkbook(WorkbookTableDto workbookTableDto);
  Future<void> deleteWorkbook(int workbookId);
}