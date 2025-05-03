import 'package:mongo_ai/create/data/dto/response/open_ai_response_dto.dart';
import 'package:mongo_ai/create/data/mapper/response/output_mapper.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

extension OpenAiResponseMapper on OpenAiResponseDto {
  OpenAiResponse toContent() {
    return OpenAiResponse(
      id: id,
      status: status,
      error: error,
      instructions: instructions,
      output: output.map((e) => e.toOutput()).toList(),
    );
  }
}
