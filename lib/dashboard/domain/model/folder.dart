import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder.freezed.dart';

@freezed
abstract class Folder with _$Folder {
  const factory Folder({
    required int folderId,
    required String folderName,
    required int teamId,
    required DateTime createdAt,
  }) = _Folder;
}