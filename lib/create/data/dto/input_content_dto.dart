import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';

part 'input_content_dto.g.dart';

/// sealed 클래스로 외부에서의 임플리먼트를 막고,
/// 같은 파일 내에서만 하위 타입을 정의합니다.
sealed class InputContentDto {
  String get type;
  Map<String, dynamic> toJson();

  /// factory를 통해 json 타입에 맞는 구현체로 변환
  static InputContentDto fromJson(Map<String, dynamic> json) {
    final t = json['type'] as String;
    switch (t) {
      case 'input_text':
        return InputTextDto.fromJson(json);
      case 'input_image':
        return InputImageDto.fromJson(json);
      case 'input_file':
        return InputFileDto.fromJson(json);
      default:
        throw const AppException.openAIType(
          message: '지원하지 않는 데이터 타입입니다.',
        );
    }
  }
}

@JsonSerializable()
class InputTextDto extends InputContentDto {
  @override
  final String type;
  final String text;

  InputTextDto({
    this.type = 'input_text',
    required this.text,
  });

  factory InputTextDto.fromJson(Map<String, dynamic> json) =>
      _$InputTextDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InputTextDtoToJson(this);
}

@JsonSerializable()
class InputImageDto extends InputContentDto {
  @override
  final String type;
  final String imageExtension;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  InputImageDto({
    this.type = 'input_image',
    required this.imageExtension,
    required this.imageUrl,
  });

  factory InputImageDto.fromJson(Map<String, dynamic> json) =>
      _$InputImageDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final map = _$InputImageDtoToJson(this);
    map['image_url'] = 'data:image/$imageExtension;base64,$imageUrl';
    return map;
  }
}

@JsonSerializable()
class InputFileDto extends InputContentDto {
  @override
  final String type;
  final String filename;
  @JsonKey(name: 'file_data')
  final String fileData;

  InputFileDto({
    this.type = 'input_file',
    required this.filename,
    required this.fileData,
  });

  factory InputFileDto.fromJson(Map<String, dynamic> json) =>
      _$InputFileDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final map = _$InputFileDtoToJson(this);
    map['file_data'] = 'data:application/pdf;base64,$fileData';
    return map;
  }
}
