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
