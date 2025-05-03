import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_dto.g.dart';

@JsonSerializable()
class ContentDto {
  final String type;
  final List<dynamic> annotations;
  final String text;

  ContentDto({
    required this.type,
    required this.annotations,
    required this.text,
  });

  factory ContentDto.fromJson(Map<String, dynamic> json) =>
      _$ContentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ContentDtoToJson(this);
}
