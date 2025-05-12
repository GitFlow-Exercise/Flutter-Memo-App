import 'package:json_annotation/json_annotation.dart';

part 'temp_user_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class TempUserDto {
  String? email;
  String? password;

  TempUserDto({this.email, this.password});

  factory TempUserDto.fromJson(Map<String, dynamic> json) => _$TempUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TempUserDtoToJson(this);
}