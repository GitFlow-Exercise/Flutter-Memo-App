import 'package:mongo_ai/dashboard/data/data_source/workbook_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_view_dto.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';

class MockWorkbookDataSourceImpl implements WorkbookDataSource {
  MockWorkbookDataSourceImpl();

  List<WorkbookViewDto> workbooks = [
    WorkbookViewDto(
      workbookId: 1,
      workbookName: 'Flutter 기초',
      userId: 'user123',
      bookmark: true,
      level: 1,
      folderId: 10,
      folderName: '기초학습',
      teamId: 5,
      teamName: '팀A',
      createdAt: '2025-05-10',
      lastOpen: '2025-05-18',
      deletedAt: null,
    ),
    WorkbookViewDto(
      workbookId: 2,
      workbookName: 'Dart 심화',
      userId: 'user456',
      bookmark: false,
      level: 2,
      folderId: 20,
      folderName: '심화과정',
      teamId: 6,
      teamName: '팀B',
      createdAt: '2025-05-10',
      lastOpen: '2025-05-18',
      deletedAt: null,
    ),
    WorkbookViewDto(
      workbookId: 3,
      workbookName: 'UI/UX 디자인',
      userId: 'user789',
      bookmark: true,
      level: 3,
      folderId: 30,
      folderName: '디자인',
      teamId: 1,
      teamName: '팀C',
      createdAt: '2025-05-10',
      lastOpen: '2025-05-18',
      deletedAt: '2025-05-16',
    ),
  ];

  @override
  Future<List<WorkbookViewDto>> getWorkbooksByCurrentTeamId(int teamId) async {
    return workbooks.where((e) => e.teamId == teamId).toList();
  }

  @override
  Future<WorkbookViewDto> createWorkbook(
    WorkbookTableDto workbookTableDto,
  ) async {
    return WorkbookViewDto(
      workbookId: workbookTableDto.workbookId,
      workbookName: workbookTableDto.workbookName,
    );
  }

  @override
  Future<void> updateWorkbook(WorkbookTableDto workbookTableDto) async {
    workbooks =
        workbooks
            .map(
              (e) =>
                  e.workbookId == workbookTableDto.workbookId
                      ? WorkbookViewDto(
                        workbookId: workbookTableDto.workbookId,
                        workbookName: workbookTableDto.workbookName,
                      )
                      : e,
            )
            .toList();
  }

  @override
  Future<void> deleteWorkbook(int workbookId) async {
    workbooks = workbooks.where((e) => e.workbookId != workbookId).toList();
  }
}
