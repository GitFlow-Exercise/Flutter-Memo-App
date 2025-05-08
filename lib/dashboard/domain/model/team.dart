import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  @JsonKey(name: 'team_id')
  final int teamId;

  @JsonKey(name: 'team_name')
  final String teamName;

  @JsonKey(name: 'team_image')
  final String? teamImage;

  const Team({
    required this.teamId,
    required this.teamName,
    this.teamImage,
  });

  factory Team.fromJson(Map<String, dynamic> json) =>
      _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}