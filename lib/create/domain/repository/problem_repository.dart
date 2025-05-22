import 'package:mongo_ai/core/exception/app_exception.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/create/domain/model/problem.dart';

abstract interface class ProblemRepository {
  Future<Result<void, AppException>> createProblems(
    List<Problem> problemsm,
    int workbookId,
  );

  Future<Result<List<Problem>, AppException>> getProblemsByWorkbookId(
    int workbookId,
  );
}
