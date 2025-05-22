import 'package:json_annotation/json_annotation.dart';

part 'problem_dto.g.dart';

@JsonSerializable()
class ProblemDto {
  @JsonKey(name: 'problem_id')
  final int? problemId;

  @JsonKey(name: 'workbook_id')
  final int workbookId;

  @JsonKey(name: 'problem_label')
  final String problemLabel;

  @JsonKey(name: 'question')
  final String question;

  @JsonKey(name: 'passage')
  final String passage;

  @JsonKey(name: 'options')
  final List<String> options;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  const ProblemDto({
    this.problemId,
    required this.workbookId,
    required this.problemLabel,
    required this.question,
    required this.passage,
    required this.options,
    this.createdAt,
  });

  factory ProblemDto.fromJson(Map<String, dynamic> json) =>
      _$ProblemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemDtoToJson(this);
}
