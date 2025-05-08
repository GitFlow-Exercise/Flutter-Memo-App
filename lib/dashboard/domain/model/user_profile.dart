import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'user_name')
  final String userName;

  @JsonKey(name: 'user_image')
  final String? userImage;

  const UserProfile({
    required this.userId,
    required this.userName,
    this.userImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}