import 'package:freezed_annotation/freezed_annotation.dart';

part 'workbook.freezed.dart';

@freezed
abstract class Workbook with _$Workbook {
  const factory Workbook({
    required int workbookId,
    required String workbookName,
    String? userId,
    String? userName,
    required bool bookmark,
    int? level,
    int? folderId,
    String? folderName,
    required int teamId,
    required String teamName,
    required DateTime createdAt,
    DateTime? lastOpen,
    DateTime? deletedAt,
  }) = _Workbook;
}