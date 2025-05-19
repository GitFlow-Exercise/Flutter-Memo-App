import 'package:json_annotation/json_annotation.dart';

part 'workbook_table_dto.g.dart';

@JsonSerializable()
class WorkbookTableDto {
  @JsonKey(name: 'workbook_id')
  num? workbookId;

  @JsonKey(name: 'workbook_name')
  String? workbookName;

  @JsonKey(name: 'user_id')
  String? userId;

  @JsonKey(name: 'bookmark')
  bool? bookmark;

  @JsonKey(name: 'level')
  num? level;

  @JsonKey(name: 'folder_id')
  num? folderId;

  @JsonKey(name: 'team_id')
  num? teamId;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'last_open')
  String? lastOpen;

  @JsonKey(name: 'deleted_at')
  String? deletedAt;

  WorkbookTableDto({
    this.workbookId,
    this.userId,
    this.workbookName,
    this.bookmark,
    this.level,
    this.folderId,
    this.teamId,
    this.createdAt,
    this.lastOpen,
    this.deletedAt
  });

  factory WorkbookTableDto.fromJson(Map<String, dynamic> json) =>
      _$WorkbookTableDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkbookTableDtoToJson(this);
}
