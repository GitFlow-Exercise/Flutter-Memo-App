import 'package:json_annotation/json_annotation.dart';

part 'prompt_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PromptDto {
  int? id;
  String? name;
  String? detail;

  PromptDto({required this.id, required this.name, required this.detail});

  factory PromptDto.fromJson(Map<String, dynamic> json) =>
      _$PromptDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PromptDtoToJson(this);
}
