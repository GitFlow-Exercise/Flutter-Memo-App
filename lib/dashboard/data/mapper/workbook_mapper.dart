import 'package:mongo_ai/dashboard/data/dto/workbook_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

extension WorkbookMapper on WorkbookDto {
  Workbook toWorkbook() {
    return Workbook(
      // non-nullable
      workbookId: (workbookId ?? 0).toInt(),
      workbookName: workbookName ?? '',
      bookmark: bookmark ?? false,
      teamId: (teamId ?? 0).toInt(),
      teamName: teamName ?? '',
      createdAt: DateTime.parse(createdAt ?? '1970-01-01'),

      // nullable
      userId: userId,
      userName: userName,
      level: level?.toInt(),
      folderId: folderId?.toInt(),
      folderName: folderName,
      lastOpen: lastOpen != null ? DateTime.parse(lastOpen!) : null,
      deletedAt: deletedAt != null ? DateTime.parse(deletedAt!) : null,
    );
  }
}