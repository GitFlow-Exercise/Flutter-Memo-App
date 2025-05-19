import 'package:mongo_ai/dashboard/data/dto/folder_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/folder.dart';

extension FolderMapper on FolderDto {
  Folder toFolder() {
    return Folder(
      folderId: (folderId ?? 0).toInt(),
      folderName: folderName ?? '',
      teamId: (teamId ?? 0).toInt(),
      createdAt: DateTime.parse(createdAt ?? '1970-01-01'),
    );
  }
}

extension FolderDtoMapper on Folder {
  FolderDto toFolderDto() {
    return FolderDto(
      folderId: folderId,
      folderName: folderName,
      teamId: teamId,
      createdAt: createdAt.toIso8601String(),
      // 필요에 따라 parentId 등 기타 필드도 매핑
    );
  }
}