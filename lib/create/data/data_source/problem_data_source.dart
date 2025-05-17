import 'package:mongo_ai/create/data/dto/problem_dto.dart';

abstract interface class ProblemDataSource {
  Future<void> createProblems(List<ProblemDto> problems);
}
