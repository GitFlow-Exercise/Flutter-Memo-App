import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response_output.dart';

part 'open_ai_response.freezed.dart';

@freezed
abstract class OpenAiResponse with _$OpenAiResponse {
  const factory OpenAiResponse({
    required String id,
    required String status,
    Object? error,
    required String instructions,
    required List<OpenAIResponseOutput> output,
  }) = _OpenAiResponse;
}

// 바로 응답값의 content를 반환해주는 Extension
extension GetContent on OpenAiResponse {
  String getContent() {
    return output[0].content[0].text;
  }
}
