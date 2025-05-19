import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';
import 'package:mongo_ai/dashboard/domain/repository/folder_repository.dart';
import '../../../core/di/test_di.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';

void main() {
  late FolderRepository folderRepository;
  const teamId = 1;
  const folderId = 1;
  const folderName = 'folderName1';

  final folderDto = FolderDto(
    folderId: folderId,
    folderName: folderName,
    teamId: teamId,
    createdAt: '',
  );

  final folder = Folder(
    folderId: folderId,
    folderName: folderName,
    teamId: teamId,
    createdAt: DateTime.now(),
  );

  setUpAll(() {
    mockdDISetup();
    folderRepository = mockLocator();
  });

  test('getFoldersByCurrentTeamId test', () async {
    final result = await folderRepository.getFoldersByCurrentTeamId(1);

    switch (result) {
      case Success<List<Folder>, AppException>():
        for (final folder in result.data) {
          expect(folder, isA<Folder>());
          expect(folder.teamId, equals(teamId));
        }
        break;
      case Error<List<Folder>, AppException>():
        expect(result, isA<Error<List<Folder>, AppException>>());
        break;
    }
  });

  test('createFolder returns Folder on Success', () async {
    final result = await folderRepository.createFolder(folderDto);

    switch (result) {
      case Success<Folder, AppException>():
        final f = result.data;
        expect(f, isA<Folder>());
        expect(f.folderId, equals(folderDto.folderId));
        expect(f.folderName, equals(folderDto.folderName));
        expect(f.teamId, equals(folderDto.teamId));
        break;
      case Error<Folder, AppException>():
        expect(result, isA<Error<List<Folder>, AppException>>());
    }
  });

  test('updateFolder returns updated Folder on Success', () async {
    final result = await folderRepository.updateFolder(folder);

    switch (result) {
      case Success<Folder, AppException>():
        final f = result.data;
        expect(f.folderId, equals(folder.folderId));
        expect(f.folderName, equals(folder.folderName));
        break;
      case Error<Folder, AppException>():
        expect(result, isA<Error<List<Folder>, AppException>>());
    }
  });

  test('deleteFolder returns deleted Folder on Success', () async {
    final result = await folderRepository.deleteFolder(folder);

    switch (result) {
      case Success<Folder, AppException>():
        final f = result.data;
        expect(f.folderId, equals(folder.folderId));
        expect(f.folderName, equals(folder.folderName));
        break;
      case Error<Folder, AppException>():
        expect(result, isA<Error<List<Folder>, AppException>>());
    }
  });
}
