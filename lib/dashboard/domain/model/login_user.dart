import 'package:json_annotation/json_annotation.dart';

part 'login_user.g.dart';

@JsonSerializable()
class LoginUser {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'user_name')
  final String userName;

  @JsonKey(name: 'user_image')
  final String? userImage;

  const LoginUser({
    required this.userId,
    required this.userName,
    this.userImage,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}