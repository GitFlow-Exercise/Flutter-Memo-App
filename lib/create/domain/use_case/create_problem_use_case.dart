import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/request/open_ai_body.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/domain/repository/open_ai_repository.dart';

class CreateProblemUseCase {
  final OpenAiRepository _repository;

  const CreateProblemUseCase(this._repository);

  Future<Result<OpenAiResponse, AppException>> getHomeInfo(
      OpenAiBody body) async {
    return await _repository.createProblem(body);
  }
}
