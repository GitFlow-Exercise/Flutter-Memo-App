import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/converter/input_converter.dart';
import 'package:mongo_ai/create/data/dto/request/input_content_dto.dart';

part 'message_input_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageInputDto {
  final String role;
  @InputContentListConverter()
  final List<InputContentDto> content;

  MessageInputDto({required this.role, required this.content});

  factory MessageInputDto.fromJson(Map<String, dynamic> json) =>
      _$MessageInputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageInputDtoToJson(this);
}
