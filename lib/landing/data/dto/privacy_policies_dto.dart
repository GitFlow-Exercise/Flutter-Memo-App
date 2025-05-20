import 'package:json_annotation/json_annotation.dart';

part 'privacy_policies_dto.g.dart';

@JsonSerializable()
class PrivacyPoliciesDto {
  num? id;
  String? content;
  String? language;

  PrivacyPoliciesDto({
    this.id,
    this.content,
    this.language,
  });

  factory PrivacyPoliciesDto.fromJson(Map<String, dynamic> json) => _$PrivacyPoliciesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyPoliciesDtoToJson(this);
}