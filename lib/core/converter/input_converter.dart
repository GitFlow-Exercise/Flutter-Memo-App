import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/create/data/dto/input_content_dto.dart';

// InputContent을 자동으로 변환시켜주는 converter
class InputContentListConverter
    implements JsonConverter<List<InputContentDto>, List<dynamic>> {
  const InputContentListConverter();

  @override
  List<InputContentDto> fromJson(List<dynamic> json) =>
      json.cast<Map<String, dynamic>>().map(InputContentDto.fromJson).toList();

  @override
  List<Map<String, dynamic>> toJson(List<InputContentDto> objects) => objects
      .map((e) => (e as dynamic).toJson() as Map<String, dynamic>)
      .toList();
}
