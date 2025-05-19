import 'package:json_annotation/json_annotation.dart';

part 'team_dto.g.dart';

@JsonSerializable()
class TeamDto {
  @JsonKey(name: 'team_id')
  num? teamId;

  @JsonKey(name: 'team_name')
  String? teamName;

  @JsonKey(name: 'team_image')
  String? teamImage;

  TeamDto({
    this.teamId,
    this.teamName,
    this.teamImage,
  });

  factory TeamDto.fromJson(Map<String, dynamic> json) =>
      _$TeamDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TeamDtoToJson(this);
}