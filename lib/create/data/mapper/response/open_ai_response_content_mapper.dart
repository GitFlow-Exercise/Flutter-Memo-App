import 'package:mongo_ai/create/data/dto/response/open_ai_response_content_dto.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response_content.dart';

extension ContentMapper on OpenAIResponseContentDto {
  OpenAIResponseContent toContent() {
    return OpenAIResponseContent(
      type: type,
      annotations: annotations,
      text: text,
    );
  }
}
