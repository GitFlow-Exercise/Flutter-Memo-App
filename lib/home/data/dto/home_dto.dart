import 'package:json_annotation/json_annotation.dart';

part 'home_dto.g.dart';

@JsonSerializable()
class HomeDto {
  final String title;
  final String description;
  final String imageUrl;

  const HomeDto({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory HomeDto.fromJson(Map<String, dynamic> json) =>
      _$HomeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDtoToJson(this);
}
