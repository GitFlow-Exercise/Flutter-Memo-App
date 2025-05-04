import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/core/constants/ai_constant.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';

part 'input_content_dto.g.dart';

sealed class InputContentDto {
  String get type;
  Map<String, dynamic> toJson();

  // json 타입에 맞는 구현체로 변환
  static InputContentDto fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case AiConstant.inputText:
        return InputTextDto.fromJson(json);
      case AiConstant.inputImage:
        return InputImageDto.fromJson(json);
      case AiConstant.inputFile:
        return InputFileDto.fromJson(json);
      default:
        throw const AppException.openAIType(message: '지원하지 않는 데이터 타입입니다.');
    }
  }
}

@JsonSerializable()
class InputTextDto extends InputContentDto {
  @override
  final String type;
  final String text;

  InputTextDto({required this.type, required this.text});

  factory InputTextDto.fromJson(Map<String, dynamic> json) =>
      _$InputTextDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputTextDtoToJson(this);
}

@JsonSerializable()
class InputImageDto extends InputContentDto {
  @override
  final String type;
  @JsonKey(includeToJson: false) // 확장자는 toJson 함수에서 제외
  final String imageExtension;
  @JsonKey(name: 'image_url') // Json key 재설정
  final String base64;

  InputImageDto({
    required this.type,
    required this.imageExtension,
    required this.base64,
  });

  factory InputImageDto.fromJson(Map<String, dynamic> json) =>
      _$InputImageDtoFromJson(json);

  // base64 데이터와
  // open AI 필수 속성값 추가하여 재설정
  @override
  Map<String, dynamic> toJson() {
    final map = _$InputImageDtoToJson(this);
    map['image_url'] = 'data:image/$imageExtension;base64,$base64';
    return map;
  }
}

@JsonSerializable()
class InputFileDto extends InputContentDto {
  @override
  final String type;
  final String filename;
  @JsonKey(name: 'file_data')
  final String base64;

  InputFileDto({
    required this.type,
    required this.filename,
    required this.base64,
  });

  factory InputFileDto.fromJson(Map<String, dynamic> json) =>
      _$InputFileDtoFromJson(json);

  // base64 데이터와
  // open AI 필수 속성값 추가하여 재설정
  @override
  Map<String, dynamic> toJson() {
    final map = _$InputFileDtoToJson(this);
    map['file_data'] = 'data:application/pdf;base64,$base64';
    return map;
  }
}
