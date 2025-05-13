import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

part 'create_workbook_params.freezed.dart';

@freezed
abstract class CreateTemplateParams with _$CreateTemplateParams {
  const factory CreateTemplateParams({
    required OpenAiResponse response,
    required Prompt prompt,
  }) = _CreateTemplateParams;
}
