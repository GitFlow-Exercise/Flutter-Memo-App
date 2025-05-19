import 'package:mongo_ai/dashboard/data/data_source/workbook_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_view_dto.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';

class WorkbookDataSourceImpl implements WorkbookDataSource {
  WorkbookDataSourceImpl();

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
      createdAt: '2025-05-10T14:30:00Z',
      lastOpen: '2025-05-18T09:00:00Z',
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
      createdAt: '2025-04-01T08:15:00Z',
      lastOpen: '2025-05-17T16:45:00Z',
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
      teamId: 7,
      teamName: '팀C',
      createdAt: '2025-03-20T12:00:00Z',
      lastOpen: '2025-05-15T11:20:00Z',
      deletedAt: '2025-05-16T10:00:00Z',
    ),
  ];

  @override
  Future<List<WorkbookViewDto>> getWorkbooksByCurrentTeamId(int teamId) async {
    return workbooks;
  }

  @override
  Future<WorkbookViewDto> createWorkbook(
    WorkbookTableDto workbookTableDto,
  ) async {
    return workbooks[0];
  }

  @override
  Future<void> updateWorkbook(WorkbookTableDto workbookTableDto) async {
    workbooks =
        workbooks
            .map(
              (e) =>
                  e.workbookId == workbookTableDto.workbookId
                      ? WorkbookViewDto(
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
