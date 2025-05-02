import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';

part 'input_content_dto.g.dart';

@JsonSerializable()
class InputText implements InputContent {
  @override
  final String type;
  final String text;

  InputText({this.type = 'input_text', required this.text});

  factory InputText.fromJson(Map<String, dynamic> json) =>
      _$InputTextFromJson(json);
  Map<String, dynamic> toJson() => _$InputTextToJson(this);
}

@JsonSerializable()
class InputImage implements InputContent {
  @override
  final String type;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  InputImage({this.type = 'input_image', required this.imageUrl});

  factory InputImage.fromJson(Map<String, dynamic> json) =>
      _$InputImageFromJson(json);
  Map<String, dynamic> toJson() => _$InputImageToJson(this);
}

@JsonSerializable()
class InputFile implements InputContent {
  @override
  final String type;
  final String filename;
  @JsonKey(name: 'file_data')
  final String fileData;

  InputFile(
      {this.type = 'input_file',
      required this.filename,
      required this.fileData});

  factory InputFile.fromJson(Map<String, dynamic> json) =>
      _$InputFileFromJson(json);
  Map<String, dynamic> toJson() => _$InputFileToJson(this);
}

// 기본 타입
abstract class InputContent {
  String get type;

  // generated code가 호출할 수 있게, static 팩토리 메서드로 등록
  static InputContent fromJson(Map<String, dynamic> json) =>
      inputContentFromJson(json);
}

InputContent inputContentFromJson(Map<String, dynamic> json) {
  final type = json['type'];
  switch (type) {
    case 'input_text':
      return InputText.fromJson(json);
    case 'input_image':
      return InputImage.fromJson(json);
    case 'input_file':
      return InputFile.fromJson(json);
    default:
      throw const AppException.openAIType(message: '지원하지 않는 타입입니다.');
  }
}

// InputContent을 자동으로 변환시켜주는 converter
class InputContentListConverter
    implements JsonConverter<List<InputContent>, List<dynamic>> {
  const InputContentListConverter();

  @override
  List<InputContent> fromJson(List<dynamic> json) =>
      json.cast<Map<String, dynamic>>().map(InputContent.fromJson).toList();

  @override
  List<Map<String, dynamic>> toJson(List<InputContent> objects) => objects
      .map((e) => (e as dynamic).toJson() as Map<String, dynamic>)
      .toList();
}
