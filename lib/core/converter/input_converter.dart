import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/create/data/dto/request/input_content_dto.dart';

// InputContent을 자동으로 변환시켜주는 converter
// 사실상 tpJson만 이용되고, fromJson은 사용안됨.
//  -> JsonConverter implements시 override 필수라 어쩔 수 없이 재정의
class InputContentListConverter
    implements JsonConverter<List<InputContentDto>, List<dynamic>> {
  const InputContentListConverter();

  @override
  List<InputContentDto> fromJson(List<dynamic> json) =>
      json.cast<Map<String, dynamic>>().map(InputContentDto.fromJson).toList();

  // InputContentDto는 세 가지 종류로,
  // -> text, image, file
  //    각 객체에 맞게 toJson 하도록 converter 설정
  @override
  List<Map<String, dynamic>> toJson(List<InputContentDto> objects) =>
      objects
          .map((e) => (e as dynamic).toJson() as Map<String, dynamic>)
          .toList();
}
