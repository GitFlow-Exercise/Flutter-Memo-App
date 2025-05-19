import 'package:json_annotation/json_annotation.dart';

part 'user_profile_dto.g.dart';

@JsonSerializable()
class UserProfileDto {
  @JsonKey(name: 'user_id')
  String? userId;

  @JsonKey(name: 'user_name')
  String? userName;

  @JsonKey(name: 'user_image')
  String? userImage;

  UserProfileDto({
    this.userId,
    this.userName,
    this.userImage,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileDtoToJson(this);
}