import 'package:mongo_ai/create/data/dto/response/output_dto.dart';
import 'package:mongo_ai/create/data/mapper/response/content_mapper.dart';
import 'package:mongo_ai/create/domain/model/response/output.dart';

extension OutputMapper on OutputDto {
  Output toOutput() {
    return Output(
      id: id,
      type: type,
      status: status,
      content: content.map((e) => e.toContent()).toList(),
      role: role,
    );
  }
}
