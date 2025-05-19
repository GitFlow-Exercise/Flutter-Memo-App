import 'package:json_annotation/json_annotation.dart';

part 'folder_dto.g.dart';

@JsonSerializable()
class FolderDto {
  @JsonKey(name: 'folder_id')
  num? folderId;

  @JsonKey(name: 'folder_name')
  String? folderName;

  @JsonKey(name: 'team_id')
  num? teamId;

  @JsonKey(name: 'created_at')
  String? createdAt;

  FolderDto({
    this.folderId,
    this.folderName,
    this.teamId,
    this.createdAt,
  });


  factory FolderDto.fromJson(Map<String, dynamic> json) =>
      _$FolderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FolderDtoToJson(this);
}
