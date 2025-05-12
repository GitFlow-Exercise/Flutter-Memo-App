import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';

class CreateWorkBookParams {
  final OpenAiResponse response;
  final Prompt prompt;
  CreateWorkBookParams({required this.response, required this.prompt});
}
