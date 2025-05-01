import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/home/data/dto/base_dto.dart';

part 'home_dto.g.dart';

@JsonSerializable()
class HomeDto implements BaseDto {
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

  @override
  Map<String, dynamic> toJson() => _$HomeDtoToJson(this);

  @override
  String? getId() => title;
}
