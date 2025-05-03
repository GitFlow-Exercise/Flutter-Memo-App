import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/data/dto/response/content_dto.dart';

part 'output_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OutputDto {
  final String id;
  final String type;
  final String status;
  final List<ContentDto> content;
  final String role;

  OutputDto({
    required this.id,
    required this.type,
    required this.status,
    required this.content,
    required this.role,
  });

  factory OutputDto.fromJson(Map<String, dynamic> json) =>
      _$OutputDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OutputDtoToJson(this);
}
