import 'package:mongo_ai/dashboard/data/dto/workbook_view_dto.dart';
import 'package:mongo_ai/dashboard/data/dto/workbook_table_dto.dart';
import 'package:mongo_ai/dashboard/domain/model/workbook.dart';

// DB에서 가져올 때는 WorkbookDto 형태로 가져옴.
// View에서 userName, folderName, teamName가 포함된 형태로 가져옴.
extension WorkbookMapper on WorkbookViewDto {
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

// DB로 보낼 때는 WorkbookTableDto 형태로 보냄.
// userName, folderName, teamName은 View에만 있고, Workbook 테이블에는 없음.
extension WorkbookDtoMapper on Workbook {
  WorkbookTableDto toWorkbookTableDto() {
    return WorkbookTableDto(
      workbookId: workbookId,
      userId: userId,
      workbookName: workbookName,   // not null
      bookmark: bookmark,
      level: level,
      folderId: folderId,
      teamId: teamId,               // not null
      createdAt: createdAt.toIso8601String(),
      lastOpen: lastOpen?.toIso8601String(),
      deletedAt: deletedAt?.toIso8601String(),
    );
  }
}