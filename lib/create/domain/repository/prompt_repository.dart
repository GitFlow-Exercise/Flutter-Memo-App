import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';

abstract interface class PromptRepository {
  Future<Result<List<Prompt>, AppException>> getPrompts();
}
