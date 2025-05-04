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
