import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'create_workbook_params.freezed.dart';

@freezed
abstract class CreateTemplateParams with _$CreateTemplateParams {
  const factory CreateTemplateParams({
    // 만약, 유형을 하나만 선택할시,
    // 클린 텍스트 리스트 제외하고,
    // 각 리스트에는 데이터가 하나씩만 들어갑니다.
    required List<String> cleanText, // 클린 텍스트 리스트
    required List<OpenAiResponse> response, // Open AI 응답 리스트
    required List<Prompt> prompt, // 프롬프트 리스트
  }) = _CreateTemplateParams;
}
