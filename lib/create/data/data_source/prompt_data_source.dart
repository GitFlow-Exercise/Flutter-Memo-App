import 'package:mongo_ai/create/data/dto/prompt_dto.dart';

abstract interface class PromptDataSource {
  Future<List<PromptDto>> getPrompts();
}
