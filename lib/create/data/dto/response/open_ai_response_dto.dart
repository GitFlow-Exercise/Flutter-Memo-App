import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_output_dto.dart';

part 'open_ai_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenAiResponseDto {
  final String id;
  final String status;
  final Object? error;
  final String instructions;
  final List<OpenAIResponseOutputDto> output;

  OpenAiResponseDto({
    required this.id,
    required this.status,
    this.error,
    required this.instructions,
    required this.output,
  });

  factory OpenAiResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OpenAiResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OpenAiResponseDtoToJson(this);
}

// {
//     "id": "resp_681488fce6b481929231669ebc7d18800961d878d81fe63f",
//     "object": "response",
//     "created_at": 1746176252,
//     "status": "completed",
//     "error": null,
//     "incomplete_details": null,
//     "instructions": "내 이름을 말할 때 이모티콘도 넣고 예쁘게 말해줘",
//     "max_output_tokens": null,
//     "model": "gpt-4.1-2025-04-14",
//     "output": [
//         {
//             "id": "msg_681488fd89148192909d7210db9cc97c0961d878d81fe63f",
//             "type": "message",
//             "status": "completed",
//             "content": [
//                 {
//                     "type": "output_text",
//                     "annotations": [],
//                     "text": "당연히 기억하고 있어요! 😊  \n✨ 임명우 ✨ 님이시죠!  \n멋진 이름이에요👍 언제든 말씀해 주세요, 명우님! 😄🌟"
//                 }
//             ],
//             "role": "assistant"
//         }
//     ],
//     "parallel_tool_calls": true,
//     "previous_response_id": "resp_68144f1d31bc819282cf647c8788d3ee0961d878d81fe63f",
//     "reasoning": {
//         "effort": null,
//         "summary": null
//     },
//     "service_tier": "default",
//     "store": true,
//     "temperature": 1.0,
//     "text": {
//         "format": {
//             "type": "text"
//         }
//     },
//     "tool_choice": "auto",
//     "tools": [],
//     "top_p": 1.0,
//     "truncation": "disabled",
//     "usage": {
//         "input_tokens": 95,
//         "input_tokens_details": {
//             "cached_tokens": 0
//         },
//         "output_tokens": 45,
//         "output_tokens_details": {
//             "reasoning_tokens": 0
//         },
//         "total_tokens": 140
//     },
//     "user": null,
//     "metadata": {}
// }

// {
//     "id": "resp_6814d0c1ea388192964962454d3bded40961d878d81fe63f",
//     "object": "response",
//     "created_at": 1746194627,
//     "status": "completed",
//     "error": null,
//     "incomplete_details": null,
//     "instructions": "해당 pdf 파일에 뭐라고 작성되어있는지 내 이름을 이모티콘과 함께 부르면서 얘기해줘",
//     "max_output_tokens": null,
//     "model": "gpt-4.1-2025-04-14",
//     "output": [
//         {
//             "id": "msg_6814d10848508192a9c96e5040cb4f1a0961d878d81fe63f",
//             "type": "message",
//             "status": "completed",
//             "content": [
//                 {
//                     "type": "output_text",
//                     "annotations": [],
//                     "text": "명우님! 🐉 질문해주신 \"What is the first dragon in the book?\"에 대해 말씀드릴게요!\n\n지금 첨부해주신 pdf 파일(두 장)에는 \"드래곤\"이나 \"dragon\"에 관한 내용이 전혀 나오지 않아요.  \n이 pdf는 영어 테스트 문제(PART 1, PART 2)로 구성되어 있고, 문법 문제와 독해 문제가 있을 뿐, \"책\"에 나오는 드래곤이나 판타지와 관련된 내용은 포함되어 있지 않습니다.\n\n혹시 다른 책이나 자료를 말씀하시는 거라면, 책 제목이나 구체적인 정보를 알려주시면 더 정확하게 답변해드릴 수 있습니다! 😊✨  \n궁금한 점이 있다면 언제든지 말씀해 주세요, 명우님! 📚💬"
//                 }
//             ],
//             "role": "assistant"
//         }
//     ],
//     "parallel_tool_calls": true,
//     "previous_response_id": "resp_68145058bec08192846820784d833be50961d878d81fe63f",
//     "reasoning": {
//         "effort": null,
//         "summary": null
//     },
//     "service_tier": "default",
//     "store": true,
//     "temperature": 1.0,
//     "text": {
//         "format": {
//             "type": "text"
//         }
//     },
//     "tool_choice": "auto",
//     "tools": [],
//     "top_p": 1.0,
//     "truncation": "disabled",
//     "usage": {
//         "input_tokens": 2015,
//         "input_tokens_details": {
//             "cached_tokens": 0
//         },
//         "output_tokens": 180,
//         "output_tokens_details": {
//             "reasoning_tokens": 0
//         },
//         "total_tokens": 2195
//     },
//     "user": null,
//     "metadata": {}
// }


// {
//     "id": "resp_6814d1a8aaf48192a4409d370e1c6e210961d878d81fe63f",
//     "object": "response",
//     "created_at": 1746194856,
//     "status": "completed",
//     "error": null,
//     "incomplete_details": null,
//     "instructions": "해당 영어 지문을 1. 해당 문제 해석, 2. 문제 정답, 3. 문제 정답에 관한 해설 순으로 깔끔하게 정리해서 알려줘",
//     "max_output_tokens": null,
//     "model": "gpt-4.1-2025-04-14",
//     "output": [
//         {
//             "id": "msg_6814d1aa9c108192bcbd55aa82de284c0961d878d81fe63f",
//             "type": "message",
//             "status": "completed",
//             "content": [
//                 {
//                     "type": "output_text",
//                     "annotations": [],
//                     "text": "네, 요청하신 대로 아래와 같이 정리해드릴게요.\n\n---\n\n**1. 해당 문제 해석**\n\n23. 다음 글의 주제로 가장 적절한 것은? [3점]\n\n---\n\n**2. 문제 정답**\n\n**정답: 정보 공개(disclosure)의 장점은 개인의 선택의 자유와 자율성을 존중한다는 것이다.**  \n(다르게 표현하면: \"공개(disclosure)는 규제보다 유연하고 개인의 선택을 존중한다\"가 주제)\n\n---\n\n**3. 문제 정답에 관한 해설**\n\n이 글은 정부의 명령(mandate)과 같은 강제적인 규제(regulation)보다, 정보의 공개(disclosure)가 더 유연(flexibility)하고 자유 시장의 운영과 개인의 선택 자유(freedom of choice, autonomy)를 존중한다는 점을 여러 예시와 함께 설명하고 있습니다.  \n예를 들어, 각종 규제로 인해 소비자가 원하지 않는 제품이 생산될 수 있고, 자동차 안전 정보, 음식 열량 정보의 공개는 소비자가 자신의 필요에 따라 정보를 활용할 수 있게 하며, 타인에게 불필요한 간섭을 하지 않는다는 점을 강조합니다.  \n즉, 정보 공개는 개인의 의사결정의 자율성과 질(quality)을 보장 또는 촉진한다는 것이 글의 핵심 주제입니다.\n\n---\n\n필요하다면 보기 선택지도 분석해드릴 수 있습니다! 추가 설명이 필요하면 말씀해 주세요."
//                 }
//             ],
//             "role": "assistant"
//         }
//     ],
//     "parallel_tool_calls": true,
//     "previous_response_id": "resp_68145058bec08192846820784d833be50961d878d81fe63f",
//     "reasoning": {
//         "effort": null,
//         "summary": null
//     },
//     "service_tier": "default",
//     "store": true,
//     "temperature": 1.0,
//     "text": {
//         "format": {
//             "type": "text"
//         }
//     },
//     "tool_choice": "auto",
//     "tools": [],
//     "top_p": 1.0,
//     "truncation": "disabled",
//     "usage": {
//         "input_tokens": 947,
//         "input_tokens_details": {
//             "cached_tokens": 0
//         },
//         "output_tokens": 320,
//         "output_tokens_details": {
//             "reasoning_tokens": 0
//         },
//         "total_tokens": 1267
//     },
//     "user": null,
//     "metadata": {}
// }