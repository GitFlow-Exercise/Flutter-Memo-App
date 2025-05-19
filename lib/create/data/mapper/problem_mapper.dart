import 'package:mongo_ai/create/data/dto/problem_dto.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

extension ProblemDtoMapper on Problem {
  ProblemDto toProblemDto(String workbookId) {
    return ProblemDto(
      workbookId: workbookId,
      problemLabel: problemType,
      question: question,
      passage: passage,
      options: options,
    );
  }
}
