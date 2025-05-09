import 'package:mongo_ai/dashboard/data/dto/workbook_dto.dart';

abstract interface class WorkbookDataSource {
  Future<List<WorkbookDto>> getWorkbooksByCurrentTeamId(int teamId);
}