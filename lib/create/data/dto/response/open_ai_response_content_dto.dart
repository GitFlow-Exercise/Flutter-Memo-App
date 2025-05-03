import 'package:freezed_annotation/freezed_annotation.dart';

part 'open_ai_response_content_dto.g.dart';

@JsonSerializable()
class OpenAIResponseContentDto {
  final String type;
  final List<dynamic> annotations;
  final String text;

  OpenAIResponseContentDto({
    required this.type,
    required this.annotations,
    required this.text,
  });

  factory OpenAIResponseContentDto.fromJson(Map<String, dynamic> json) =>
      _$OpenAIResponseContentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OpenAIResponseContentDtoToJson(this);
}
