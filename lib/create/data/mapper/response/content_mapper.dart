import 'package:mongo_ai/create/data/dto/response/content_dto.dart';
import 'package:mongo_ai/create/domain/model/response/content.dart';

extension ContentMapper on ContentDto {
  Content toContent() {
    return Content(
      type: type,
      annotations: annotations,
      text: text,
    );
  }
}
