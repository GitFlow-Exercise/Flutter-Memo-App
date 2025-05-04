import 'package:mongo_ai/create/data/dto/response/open_ai_response_output_dto.dart';
import 'package:mongo_ai/create/data/mapper/response/open_ai_response_content_mapper.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response_output.dart';

extension OutputMapper on OpenAIResponseOutputDto {
  OpenAIResponseOutput toOutput() {
    return OpenAIResponseOutput(
      id: id,
      type: type,
      status: status,
      content: content.map((e) => e.toContent()).toList(),
      role: role,
    );
  }
}
