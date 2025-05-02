import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/create/data/dto/request/message_input_dto.dart';

part 'open_ai_body_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenAIBodyDto {
  final String model;
  final List<MessageInputDto> input;
  final String instructions;
  @JsonKey(name: 'previous_response_id')
  final String previousResponseId;

  OpenAIBodyDto({
    required this.model,
    required this.input,
    required this.instructions,
    required this.previousResponseId,
  });

  factory OpenAIBodyDto.fromJson(Map<String, dynamic> json) =>
      _$OpenAIBodyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OpenAIBodyDtoToJson(this);
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