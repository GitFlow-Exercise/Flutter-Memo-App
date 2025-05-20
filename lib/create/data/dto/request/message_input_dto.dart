import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/utils/input_converter.dart';
import 'package:mongo_ai/create/data/dto/request/input_content_dto.dart';

part 'message_input_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageInputDto {
  final String role;
  @InputContentListConverter() // converter 설정 - 자세한 내용은 타고 들아가서 확인
  final List<InputContentDto> content;

  MessageInputDto({this.role = AiConstant.role, required this.content});

  factory MessageInputDto.fromJson(Map<String, dynamic> json) =>
      _$MessageInputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageInputDtoToJson(this);
}
