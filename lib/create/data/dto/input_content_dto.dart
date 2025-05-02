import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/core/exception/app_exception.dart';

part 'input_content_dto.g.dart';

// 기본 타입
abstract class InputContentDto {
  String get type;

  // generated code가 호출할 수 있게, static 팩토리 메서드로 등록
  static InputContentDto fromJson(Map<String, dynamic> json) =>
      inputContentDtoFromJson(json);
}

// --------------------------------
// 텍스트를 담은 body
@JsonSerializable()
class InputText implements InputContentDto {
  @override
  final String type;
  final String text;

  InputText({this.type = 'input_text', required this.text});

  factory InputText.fromJson(Map<String, dynamic> json) =>
      _$InputTextFromJson(json);
  Map<String, dynamic> toJson() => _$InputTextToJson(this);
}

// --------------------------------
// 이미지를 담은 body
@JsonSerializable()
class InputImage implements InputContentDto {
  @override
  final String type;
  final String imageExtension;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  InputImage({
    this.type = 'input_image',
    required this.imageExtension,
    required this.imageUrl,
  });

  factory InputImage.fromJson(Map<String, dynamic> json) =>
      _$InputImageFromJson(json);

  // 데이터 추가를 위한 toJson 변경
  // generate된 코드를 가져와서 데이터 추가 후 반환
  Map<String, dynamic> toJson() {
    final map = _$InputImageToJson(this);

    // 2. image_url 을 extension과 함께 다시 세팅
    map['image_url'] = 'data:image/$imageExtension;base64,$imageUrl';

    return map;
  }
}

// --------------------------------
// 파일을 담은 body
@JsonSerializable()
class InputFile implements InputContentDto {
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

  // 데이터 추가를 위한 toJson 변경
  // generate된 코드를 가져와서 데이터 추가 후 반환
  Map<String, dynamic> toJson() {
    final map = _$InputFileToJson(this);
    map['file_data'] = 'data:application/pdf;base64,$fileData';
    return map;
  }
}

// InputContent에서 type 값을 확인 후
// 해당 타입에 맞게 fromJson 함수를 반환하는 함수
InputContentDto inputContentDtoFromJson(Map<String, dynamic> json) {
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

// {
//   "model": "gpt-4.1",
//   "input":[
//         {
//             "role": "user",
//             "content": [
//               {"type": "input_text", "text": "what's in this image?"},
//             ]
//         }
//     ],
//   "instructions": "내 이름을 말할 때 이모티콘도 넣고 예쁘게 말해줘",
//     "previous_response_id": "resp_68144f1d31bc819282cf647c8788d3ee0961d878d81fe63f"
// }

// {
//   "model": "gpt-4.1",
//   "input":[
//         {
//             "role": "user",
//             "content": [
//                 { "type": "input_text", "text": "이미지 관련해서 알려줘" },
//                 {
//                     "type": "input_image",
//                     "image_url": "data:image/png;base64,"
//                 }
//             ]
//         }
//     ],
//   "instructions": "해당 영어 지문을 1. 해당 문제 해석, 2. 문제 정답, 3. 문제 정답에 관한 해설 순으로 깔끔하게 정리해서 알려줘",
//     "previous_response_id": "resp_68145058bec08192846820784d833be50961d878d81fe63f"
// }

// {
//   "model": "gpt-4.1",
//   "input":[
//         {
//             "role": "user",
//             "content": [
//                 {
//                     "type": "input_file",
//                     "filename": "test.pdf",
//                     "file_data": "data:application/pdf;base64,"
//                 },
//                 {
//                     "type": "input_text",
//                     "text": "What is the first dragon in the book?"
//                 }
//             ]
//         }
//     ],
//   "instructions": "해당 pdf 파일에 뭐라고 작성되어있는지 내 이름을 이모티콘과 함께 부르면서 얘기해줘",
//     "previous_response_id": "resp_68145058bec08192846820784d833be50961d878d81fe63f"
// }