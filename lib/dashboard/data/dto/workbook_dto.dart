import 'package:json_annotation/json_annotation.dart';

part 'workbook_dto.g.dart';

@JsonSerializable()
class WorkbookDto {
  @JsonKey(name: 'workbook_id')
  num? workbookId;

  @JsonKey(name: 'user_id')
  String? userId;

  @JsonKey(name: 'workbook_name')
  String? workbookName;

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

  WorkbookDto(
    this.workbookId,
    this.userId,
    this.workbookName,
    this.bookmark,
    this.level,
    this.folderId,
    this.teamId,
    this.createdAt,
    this.lastOpen,
    this.deletedAt,
  );

  factory WorkbookDto.fromJson(Map<String, dynamic> json) =>
      _$WorkbookDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkbookDtoToJson(this);
}
