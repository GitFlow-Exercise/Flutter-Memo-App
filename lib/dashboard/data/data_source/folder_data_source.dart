import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';

abstract interface class FolderDataSource {
  Future<List<FolderDto>> getFoldersByCurrentTeamId(int teamId);
  Future<FolderDto> createFolder(FolderDto folderDto);
  Future<void> updateFolder(FolderDto folderDto);
  Future<void> deleteFolder(int folderId);
}