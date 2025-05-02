import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/output.dart';

part 'open_ai_response.freezed.dart';
part 'open_ai_response.g.dart';

@freezed
abstract class OpenAiResponse with _$OpenAiResponse {
  const factory OpenAiResponse({
    required String id,
    required String status,
    Object? error,
    required String instructions,
    required List<Output> output,
  }) = _OpenAiResponse;

  factory OpenAiResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenAiResponseFromJson(json);
}
