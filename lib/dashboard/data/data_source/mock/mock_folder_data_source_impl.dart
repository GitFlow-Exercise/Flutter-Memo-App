import 'package:mongo_ai/dashboard/data/data_source/folder_data_source.dart';
import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';

class MockFolderDataSourceImpl implements FolderDataSource {
  MockFolderDataSourceImpl();

  List<FolderDto> folders = [
    FolderDto(
      folderId: 1,
      folderName: 'folderName1',
      teamId: 1,
      createdAt: '2025-05-10',
    ),
    FolderDto(
      folderId: 2,
      folderName: 'folderName2',
      teamId: 1,
      createdAt: '2025-05-10',
    ),
    FolderDto(
      folderId: 3,
      folderName: 'folderName3',
      teamId: 1,
      createdAt: '2025-05-10',
    ),
    FolderDto(
      folderId: 4,
      folderName: 'folderName4',
      teamId: 1,
      createdAt: '2025-05-10',
    ),
  ];

  @override
  Future<List<FolderDto>> getFoldersByCurrentTeamId(int teamId) async {
    return folders.where((e) => e.teamId == teamId).toList();
  }

  @override
  Future<FolderDto> createFolder(FolderDto folderDto) async {
    return folders[0];
  }

  @override
  Future<void> updateFolder(FolderDto folderDto) async {
    folders =
        folders
            .map((e) => e.folderId == folderDto.folderId ? folderDto : e)
            .toList();
  }

  @override
  Future<void> deleteFolder(int folderId) async {
    // 마지막 데이터 제거
    folders = folders.where((e) => e.folderId != folderId).toList();
  }
}
