import 'package:json_annotation/json_annotation.dart';

part 'temp_user_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class TempUserDto {
  String? email;
  String? password;
  String? otp;

  TempUserDto({this.email, this.password, this.otp});

  factory TempUserDto.fromJson(Map<String, dynamic> json) => _$TempUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TempUserDtoToJson(this);
}