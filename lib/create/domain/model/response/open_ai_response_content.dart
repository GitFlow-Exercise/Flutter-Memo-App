import 'package:freezed_annotation/freezed_annotation.dart';

part 'open_ai_response_content.freezed.dart';

@freezed
abstract class OpenAIResponseContent with _$OpenAIResponseContent {
  const factory OpenAIResponseContent({
    required String type,
    required List<dynamic> annotations,
    required String text,
  }) = _OpenAIResponseContent;
}
