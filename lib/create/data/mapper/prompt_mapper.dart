import 'package:mongo_ai/create/data/dto/prompt_dto.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';

extension PromptMapper on PromptDto {
  Prompt toPrompt() {
    return Prompt(
      id: id ?? 0,
      name: name ?? 'UnKnown',
      detail: detail ?? 'UnKnown',
    );
  }
}
