import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/create/data/dto/request/message_input_dto.dart';

part 'open_ai_body_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenAIBodyDto {
  final String model;
  final List<MessageInputDto> input;
  final String instructions;
  @JsonKey(name: 'previous_response_id')
  final String? previousResponseId;
  final double temperature;

  OpenAIBodyDto({
    required this.model,
    required this.input,
    required this.instructions,
    this.previousResponseId,
    required this.temperature,
  });

  factory OpenAIBodyDto.fromJson(Map<String, dynamic> json) =>
      _$OpenAIBodyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OpenAIBodyDtoToJson(this);
}
