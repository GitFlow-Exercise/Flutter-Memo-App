import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response_content.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response_output.dart';
import 'package:uuid/uuid.dart';

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

  factory OpenAiResponse.justText({required String contents}) {
    return OpenAiResponse(
      id: const Uuid().v4(),
      status: '',
      instructions: '',
      output: [
        OpenAIResponseOutput(
          id: const Uuid().v4(),
          type: '',
          status: '',
          content: [
            OpenAIResponseContent(
              type: 'output_text',
              annotations: [],
              text: contents,
            ),
          ],
          role: '',
        ),
      ],
    );
  }
}

// 바로 응답값의 content를 반환해주는 Extension
extension GetContent on OpenAiResponse {
  String getContent() {
    return output[0].content[0].text;
  }
}
