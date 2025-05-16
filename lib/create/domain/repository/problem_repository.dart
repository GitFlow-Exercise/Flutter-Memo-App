import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

abstract interface class ProblemRepository {
  Future<void> createProblems(List<Problem> problemsm, String workbookId);
}
