import 'package:mongo_ai/create/data/dto/response/open_ai_response_dto.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';

abstract interface class OpenAiDataSource {
  Future<OpenAiResponseDto> createProblum(
    OpenAiBody body,
  );
}
