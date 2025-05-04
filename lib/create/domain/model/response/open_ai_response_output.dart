import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response_content.dart';

part 'open_ai_response_output.freezed.dart';

@freezed
abstract class OpenAIResponseOutput with _$OpenAIResponseOutput {
  const factory OpenAIResponseOutput({
    required String id,
    required String type,
    required String status,
    required List<OpenAIResponseContent> content,
    required String role,
  }) = _OpenAIResponseOutput;
}
