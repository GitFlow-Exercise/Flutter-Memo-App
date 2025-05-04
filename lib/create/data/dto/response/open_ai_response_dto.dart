import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_output_dto.dart';

part 'open_ai_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenAiResponseDto {
  final String id;
  final String status;
  final Object? error;
  final String instructions;
  final List<OpenAIResponseOutputDto> output;

  OpenAiResponseDto({
    required this.id,
    required this.status,
    this.error,
    required this.instructions,
    required this.output,
  });

  factory OpenAiResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OpenAiResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OpenAiResponseDtoToJson(this);
}
