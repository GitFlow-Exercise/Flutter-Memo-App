import 'package:freezed_annotation/freezed_annotation.dart';

part 'workbook.freezed.dart';

@freezed
abstract class Workbook with _$Workbook {
  const factory Workbook({
    required int workbookId,
    String? userId,
    required String workbookName,
    String? workbookLabel,
    required bool bookmark,
    int? level,
    int? folderId,
    required int? teamId,
    required DateTime createdAt,
    DateTime? lastOpen,
    DateTime? deletedAt,
  }) = _Workbook;
}