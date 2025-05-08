import 'package:mongo_ai/create/data/dto/prompt_dto.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';

extension PickFileDtoMapper on PromptDto {
  Prompt toPickFile() {
    return Prompt(id: id ?? 0, name: name ?? 'UnKnown', detail: 'UnKnown');
  }
}
