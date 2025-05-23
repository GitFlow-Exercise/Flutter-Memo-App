import 'package:mongo_ai/create/data/dto/request/open_ai_body_dto.dart';
import 'package:mongo_ai/create/data/mapper/request/message_input_mapper.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';

extension OpenAiBodyMapper on OpenAiBody {
  OpenAIBodyDto toOpenAiBodyDto() {
    return OpenAIBodyDto(
      model: model,
      input: input.map((e) => e.toMessageInputDto()).toList(),
      instructions: instructions,
      previousResponseId: previousResponseId,
      temperature: temperature,
    );
  }
}
