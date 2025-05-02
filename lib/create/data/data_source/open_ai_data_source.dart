import 'package:mongo_ai/create/data/dto/request/open_ai_body_dto.dart';
import 'package:mongo_ai/create/data/dto/response/open_ai_response_dto.dart';

abstract interface class OpenAiDataSource {
  Future<OpenAiResponseDto> createProblem(
    OpenAIBodyDto body,
  );
}
