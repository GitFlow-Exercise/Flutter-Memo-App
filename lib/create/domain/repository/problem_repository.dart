import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

abstract interface class ProblemRepository {
  Future<Result<void, AppException>> createProblems(
    List<Problem> problemsm,
    String workbookId,
  );
}
