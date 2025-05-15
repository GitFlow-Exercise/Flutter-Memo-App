import 'package:json_annotation/json_annotation.dart';

part 'workbook_view_dto.g.dart';

@JsonSerializable()
class WorkbookViewDto {
  @JsonKey(name: 'workbook_id')
  num? workbookId;

  @JsonKey(name: 'workbook_name')
  String? workbookName;

  @JsonKey(name: 'user_id')
  String? userId;

  @JsonKey(name: 'user_name')
  String? userName;

  @JsonKey(name: 'bookmark')
  bool? bookmark;

  @JsonKey(name: 'level')
  num? level;

  @JsonKey(name: 'folder_id')
  num? folderId;

  @JsonKey(name: 'folder_name')
  String? folderName;

  @JsonKey(name: 'team_id')
  num? teamId;

  @JsonKey(name: 'team_name')
  String? teamName;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'last_open')
  String? lastOpen;

  @JsonKey(name: 'deleted_at')
  String? deletedAt;

  WorkbookViewDto({
    this.workbookId,
    this.userId,
    this.workbookName,
    this.bookmark,
    this.level,
    this.folderId,
    this.folderName,
    this.teamId,
    this.teamName,
    this.createdAt,
    this.lastOpen,
    this.deletedAt
  });

  factory WorkbookViewDto.fromJson(Map<String, dynamic> json) =>
      _$WorkbookViewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkbookViewDtoToJson(this);
}
