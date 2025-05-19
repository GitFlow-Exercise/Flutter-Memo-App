import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_content_dto.dart';

part 'open_ai_response_output_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenAIResponseOutputDto {
  final String id;
  final String type;
  final String status;
  final List<OpenAIResponseContentDto> content;
  final String role;

  OpenAIResponseOutputDto({
    required this.id,
    required this.type,
    required this.status,
    required this.content,
    required this.role,
  });

  factory OpenAIResponseOutputDto.fromJson(Map<String, dynamic> json) =>
      _$OpenAIResponseOutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OpenAIResponseOutputDtoToJson(this);
}
