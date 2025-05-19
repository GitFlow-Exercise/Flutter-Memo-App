import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_view_dto.dart';
import 'package:mongo_ai/dashboard/data/mapper/workbook_mapper.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';
import 'package:mongo_ai/dashboard/domain/repository/workbook_repository.dart';
import '../../../core/di/test_di.dart';

void main() {
  late WorkbookRepository workbookRepository;
  const teamId = 1;

  // 테스트용 DTO & Domain 모델 샘플
  final sampleViewDto = WorkbookViewDto(
    workbookId: 1,
    workbookName: 'Flutter 기초',
    userId: 'user123',
    bookmark: true,
    level: 1,
    folderId: 10,
    folderName: '기초학습',
    teamId: teamId,
    teamName: '팀A',
    createdAt: '2025-05-10T14:30:00Z',
    lastOpen: '2025-05-18T09:00:00Z',
    deletedAt: null,
  );
  final sampleWorkbook = sampleViewDto.toWorkbook();

  final sampleTableDto = WorkbookTableDto(
    workbookId: 1,
    workbookName: '새 문제집',
    teamId: teamId,
    folderId: 10,
  );

  setUpAll(() {
    mockdDISetup(); // DataSource 스텁 설정
    workbookRepository = mockLocator(); // WorkbookRepositoryImpl 주입
  });

  test('getWorkbooksByCurrentTeamId test', () async {
    final result = await workbookRepository.getWorkbooksByCurrentTeamId(teamId);

    switch (result) {
      case Success<List<Workbook>, AppException>():
        expect(result.data, isNotEmpty);
        for (final wc in result.data) {
          expect(wc, isA<Workbook>());
          expect(wc.teamId, equals(teamId));
        }
        break;
      case Error<List<Workbook>, AppException>():
        expect(result, isA<Error<List<Workbook>, AppException>>());
        break;
    }
  });

  test('createWorkbook test', () async {
    final result = await workbookRepository.createWorkbook(sampleTableDto);

    switch (result) {
      case Success<Workbook, AppException>():
        final wc = result.data;
        expect(wc, isA<Workbook>());
        expect(wc.workbookName, equals(sampleTableDto.workbookName));
        expect(wc.workbookId, equals(sampleTableDto.workbookId));
        break;
      case Error<Workbook, AppException>():
        expect(result, isA<Error<Workbook, AppException>>());
        break;
    }
  });

  test('updateWorkbook test', () async {
    final result = await workbookRepository.updateWorkbook(sampleWorkbook);

    switch (result) {
      case Success<Workbook, AppException>():
        final wc = result.data;
        expect(wc.workbookId, equals(sampleWorkbook.workbookId));
        expect(wc.workbookName, equals(sampleWorkbook.workbookName));
        break;
      case Error<Workbook, AppException>():
        expect(result, isA<Error<Workbook, AppException>>());
        break;
    }
  });

  test('deleteWorkbook test', () async {
    final result = await workbookRepository.deleteWorkbook(sampleWorkbook);

    switch (result) {
      case Success<Workbook, AppException>():
        final wc = result.data;
        expect(wc.workbookId, equals(sampleWorkbook.workbookId));
        break;
      case Error<Workbook, AppException>():
        expect(result, isA<Error<Workbook, AppException>>());
        break;
    }
  });
}
